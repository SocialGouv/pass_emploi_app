import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

const int _fakeItemsAddedToLeverageAdditionalScrollInAutocomplete = 20;

class LocationAutocomplete extends StatefulWidget {
  final Function(String newLocationQuery) _onInputLocation;
  final Function(LocationViewModel? locationViewModel) _onSelected;
  final List<LocationViewModel> _locationViewModels;
  final String _hint;

  LocationAutocomplete(
    this._onInputLocation,
    this._onSelected,
    this._locationViewModels,
    this._hint,
  ) : super();

  @override
  _LocationAutocompleteState createState() => _LocationAutocompleteState();
}

class _LocationAutocompleteState extends State<LocationAutocomplete> {
  LocationViewModel? _selectedLocationViewModel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Autocomplete<LocationViewModel>(
        optionsBuilder: (textEditingValue) {
          final newLocationQuery = textEditingValue.text;
          _deleteSelectedLocationOnTextDeletion(newLocationQuery);
          widget._onInputLocation(newLocationQuery);
          return [_fakeLocationRequiredByAutocompleteToCallOptionsViewBuilderMethod()];
        },
        onSelected: (locationViewModel) {
          _selectedLocationViewModel = locationViewModel;
          _dismissKeyboard(context);
          widget._onSelected(locationViewModel);
        },
        optionsViewBuilder: (
          BuildContext _,
          AutocompleteOnSelected<LocationViewModel> onSelected,
          Iterable<LocationViewModel> __,
        ) {
          return Align(
              alignment: Alignment.topLeft,
              child: Material(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.0)),
                ),
                child: Container(
                  width: constraints.biggest.width,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount:
                        widget._locationViewModels.length + _fakeItemsAddedToLeverageAdditionalScrollInAutocomplete,
                    itemBuilder: (BuildContext context, int index) => _listTile(index, onSelected),
                  ),
                  color: Colors.white,
                ),
                color: Colors.white,
              ));
        },
        fieldViewBuilder: (
          BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted,
        ) {
          return Focus(
            onFocusChange: (hasFocus) => _putBackLastLocationSetOnFocusLost(hasFocus, textEditingController),
            child: TextFormField(
              style: TextStyles.textSmMedium(color: AppColors.nightBlue),
              scrollPadding: const EdgeInsets.only(bottom: 130.0),
              controller: textEditingController,
              decoration: _inputDecoration(widget._hint),
              focusNode: focusNode,
            ),
          );
        },
      ),
    );
  }

  void _deleteSelectedLocationOnTextDeletion(String newLocationQuery) {
    if (newLocationQuery.isEmpty) {
      setState(() {
        _selectedLocationViewModel = null;
        widget._onSelected(null);
      });
    }
  }

  LocationViewModel _fakeLocationRequiredByAutocompleteToCallOptionsViewBuilderMethod() {
    return LocationViewModel("", Location(libelle: "", code: "", codePostal: "", type: LocationType.COMMUNE));
  }

  void _dismissKeyboard(BuildContext context) => FocusScope.of(context).unfocus();

  Widget _listTile(int index, AutocompleteOnSelected<LocationViewModel> onSelected) {
    if (index + 1 > widget._locationViewModels.length) {
      return _fakeListTileToLeverageAdditionalScrollInAutocompleteWidget();
    } else {
      return _realListTile(onSelected, index);
    }
  }

  Widget _realListTile(AutocompleteOnSelected<LocationViewModel> onSelected, int index) {
    final viewModel = widget._locationViewModels.elementAt(index);
    return GestureDetector(
      onTap: () {
        onSelected(viewModel);
        widget._onSelected(viewModel);
      },
      child: ListTile(
        title: Text(viewModel.title, style: const TextStyle(color: AppColors.nightBlue)),
      ),
    );
  }

  Widget _fakeListTileToLeverageAdditionalScrollInAutocompleteWidget() {
    return Container(height: 48, color: AppColors.lightBlue);
  }

  void _putBackLastLocationSetOnFocusLost(bool hasFocus, TextEditingController textEditingController) {
    final selectedLocationViewModel = _selectedLocationViewModel;
    if (!hasFocus && selectedLocationViewModel != null) {
      textEditingController.text = selectedLocationViewModel.title;
    }
  }

  InputDecoration _inputDecoration(String textFieldString) {
    return InputDecoration(
      contentPadding: const EdgeInsets.only(left: 24, top: 18, bottom: 18),
      labelText: textFieldString,
      labelStyle: TextStyles.textSmMedium(color: AppColors.bluePurple),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppColors.nightBlue, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppColors.nightBlue, width: 1.0),
      ),
    );
  }
}
