import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/debouncer.dart';
import 'package:pass_emploi_app/utils/keyboard.dart';

const int _fakeItemsAddedToLeverageAdditionalScrollInAutocomplete = 20;

class LocationAutocomplete extends StatelessWidget {
  final Function(String newLocationQuery) onInputLocation;
  final Function(LocationViewModel? locationViewModel) onSelectLocationViewModel;
  final String? Function() getPreviouslySelectedTitle;
  final String? Function(String? input) validator;
  final List<LocationViewModel> locationViewModels;
  final String hint;
  final GlobalKey<FormState>? formKey;

  final Debouncer _debouncer = Debouncer(duration: Duration(milliseconds: 200));

  LocationAutocomplete({
    required this.onInputLocation,
    required this.onSelectLocationViewModel,
    required this.locationViewModels,
    required this.hint,
    required this.getPreviouslySelectedTitle,
    required this.formKey,
    required this.validator,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Autocomplete<LocationViewModel>(
        optionsBuilder: (textEditingValue) {
          _debouncer.run(() {
            final newLocationQuery = textEditingValue.text;
            _deleteSelectedLocationOnTextDeletion(newLocationQuery);
            onInputLocation(newLocationQuery);
          });
          return [_fakeLocationRequiredByAutocompleteToCallOptionsViewBuilderMethod()];
        },
        onSelected: (locationViewModel) {
          Keyboard.dismiss(context);
          onSelectLocationViewModel(locationViewModel);
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
                    itemCount: locationViewModels.length + _fakeItemsAddedToLeverageAdditionalScrollInAutocomplete,
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
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: TextFormField(
                style: TextStyles.textSmMedium(color: AppColors.nightBlue),
                scrollPadding: const EdgeInsets.only(bottom: 130.0),
                controller: textEditingController,
                decoration: _inputDecoration(hint),
                focusNode: focusNode,
                validator: validator,
              ),
            ),
          );
        },
      ),
    );
  }

  void _deleteSelectedLocationOnTextDeletion(String newLocationQuery) {
    if (newLocationQuery.isEmpty) {
      onSelectLocationViewModel(null);
    }
  }

  LocationViewModel _fakeLocationRequiredByAutocompleteToCallOptionsViewBuilderMethod() {
    return LocationViewModel("", Location(libelle: "", code: "", type: LocationType.COMMUNE));
  }

  Widget _listTile(int index, AutocompleteOnSelected<LocationViewModel> onSelected) {
    if (index + 1 > locationViewModels.length) {
      return _fakeListTileToLeverageAdditionalScrollInAutocompleteWidget();
    } else {
      return _realListTile(onSelected, index);
    }
  }

  Widget _realListTile(AutocompleteOnSelected<LocationViewModel> onSelected, int index) {
    final viewModel = locationViewModels.elementAt(index);
    return GestureDetector(
      onTap: () {
        onSelected(viewModel);
        onSelectLocationViewModel(viewModel);
      },
      child: ListTile(
        title: Text(viewModel.title, style: TextStyles.textSmRegular()),
      ),
    );
  }

  Widget _fakeListTileToLeverageAdditionalScrollInAutocompleteWidget() {
    return Container(height: 48, color: AppColors.lightBlue);
  }

  void _putBackLastLocationSetOnFocusLost(bool hasFocus, TextEditingController textEditingController) {
    var title = getPreviouslySelectedTitle();
    if (!hasFocus && title != null) {
      textEditingController.text = title;
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppColors.errorRed, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppColors.errorRed, width: 1.0),
      ),
    );
  }
}
