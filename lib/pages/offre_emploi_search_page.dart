import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_search_view_model.dart';
import 'package:pass_emploi_app/redux/actions/search_location_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/button.dart';

import 'offre_emploi_list_page.dart';

class OffreEmploiSearchPage extends TraceableStatefulWidget {
  OffreEmploiSearchPage() : super(name: AnalyticsScreenNames.offreEmploiResearch);

  @override
  State<OffreEmploiSearchPage> createState() => _OffreEmploiSearchPageState();
}

class _OffreEmploiSearchPageState extends State<OffreEmploiSearchPage> {
  Location? _selectedLocation;
  var _currentLocationQuery = "";
  var _keyWord = "";
  var _shouldNavigate = true;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OffreEmploiSearchViewModel>(
      converter: (store) => OffreEmploiSearchViewModel.create(store),
      onWillChange: (_, newViewModel) {
        if (newViewModel.displayState == OffreEmploiSearchDisplayState.SHOW_CONTENT && _shouldNavigate) {
          _shouldNavigate = false;
          Navigator.push(context, MaterialPageRoute(builder: (context) => OffreEmploiListPage())).then((value) {
            _shouldNavigate = true;
          });
        }
      },
      distinct: true,
      builder: (context, viewModel) => _body(viewModel),
      onDispose: (store) => store.dispatch(ResetLocationAction()),
    );
  }

  Widget _body(OffreEmploiSearchViewModel viewModel) {
    return ListView(
      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
      shrinkWrap: true,
      children: [
        _separator(),
        Text(Strings.keyWordsTitle, style: TextStyles.textLgMedium),
        _separator(),
        _keywordTextFormField(),
        _separator(),
        Text(Strings.jobLocationTitle, style: TextStyles.textLgMedium),
        _separator(),
        _autocomplete(viewModel),
        _separator(),
        Center(
          child: primaryActionButton(
              onPressed: _isLoading(viewModel)
                  ? null
                  : () {
                      _searchingRequest(viewModel);
                      FocusScope.of(context).unfocus();
                    },
              label: Strings.searchButton),
        ),
        _separator(),
        if (viewModel.displayState == OffreEmploiSearchDisplayState.SHOW_ERROR ||
            viewModel.displayState == OffreEmploiSearchDisplayState.SHOW_EMPTY_ERROR)
          _errorTextField(viewModel),
      ],
    );
  }

  SizedBox _separator() => SizedBox(height: 24);

  TextFormField _keywordTextFormField() {
    return TextFormField(
      style: TextStyles.textSmMedium(color: AppColors.nightBlue),
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value == null || value.isEmpty) return Strings.mandatoryAccessCodeError;
        return null;
      },
      decoration: _inputDecoration(Strings.keyWordsTextField),
      onChanged: (keyword) => _keyWord = keyword,
    );
  }

  LayoutBuilder _autocomplete(OffreEmploiSearchViewModel viewModel) {
    return LayoutBuilder(
      builder: (context, constraints) => Autocomplete<LocationViewModel>(
        optionsBuilder: (textEditingValue) {
          final newLocationQuery = textEditingValue.text;
          if (newLocationQuery != _currentLocationQuery) {
            viewModel.onInputLocation(newLocationQuery);
            _currentLocationQuery = newLocationQuery;
          }
          return [_fakeLocationRequiredByAutocompleteToCallOptionsViewBuilderMethod()];
        },
        onSelected: (locationViewModel) => _selectedLocation = locationViewModel.location,
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
                    itemCount: viewModel.locations.length,
                    itemBuilder: (BuildContext context, int index) {
                      final LocationViewModel locationViewModel = viewModel.locations.elementAt(index);
                      return GestureDetector(
                        onTap: () => onSelected(locationViewModel),
                        child: ListTile(
                          title: Text(locationViewModel.title, style: const TextStyle(color: AppColors.nightBlue)),
                        ),
                      );
                    },
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
          return TextFormField(
            controller: textEditingController,
            decoration: _inputDecoration(Strings.jobLocationHint),
            focusNode: focusNode,
            onFieldSubmitted: (String value) => onFieldSubmitted(),
          );
        },
      ),
    );
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

  bool _isLoading(OffreEmploiSearchViewModel viewModel) =>
      viewModel.displayState == OffreEmploiSearchDisplayState.SHOW_LOADER;

  void _searchingRequest(OffreEmploiSearchViewModel viewModel) {
    viewModel.searchingRequest(_keyWord, _selectedLocation);
  }

  Widget _errorTextField(OffreEmploiSearchViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          viewModel.errorMessage,
          textAlign: TextAlign.center,
          style: TextStyles.textSmRegular(color: AppColors.errorRed),
        ),
      ),
    );
  }

  LocationViewModel _fakeLocationRequiredByAutocompleteToCallOptionsViewBuilderMethod() {
    return LocationViewModel("", Location(libelle: "", code: "", codePostal: "", type: LocationType.COMMUNE));
  }
}
