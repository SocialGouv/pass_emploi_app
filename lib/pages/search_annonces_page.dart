import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_search_view_model.dart';
import 'package:pass_emploi_app/redux/actions/search_location_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/button.dart';
import 'package:pass_emploi_app/widgets/carousel_button.dart';

import 'offre_emploi_list_page.dart';

enum SearchAnnoncesDisplayState { JOB_OFFERS, ALTERNATION, IMMERSION, CIVIL_SERVICE }

const int _fakeItemsAddedToLeverageAdditionalScrollInAutocomplete = 20;

class SearchAnnoncesPage extends TraceableStatefulWidget {
  SearchAnnoncesPage() : super(name: AnalyticsScreenNames.offreEmploiResearch);

  @override
  State<SearchAnnoncesPage> createState() => _OffreEmploiSearchPageState();
}

class _OffreEmploiSearchPageState extends State<SearchAnnoncesPage> {
  LocationViewModel? _selectedLocationViewModel;
  var _currentLocationQuery = "";
  var _keyWord = "";
  var _shouldNavigate = true;
  var _activeButton = 1;
  var _annonceDisplayState = SearchAnnoncesDisplayState.JOB_OFFERS;

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
        _verticalSeparator(),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            carouselButton(
                isActive: _activeButton == 1 ? true : false,
                onPressed: () => plop(1, SearchAnnoncesDisplayState.JOB_OFFERS),
                label: Strings.offresEmploiButton),
            _horizontalSeparator(),
            carouselButton(
                isActive: _activeButton == 2 ? true : false,
                onPressed: () => plop(2, SearchAnnoncesDisplayState.ALTERNATION),
                label: Strings.alternanceButton),
            _horizontalSeparator(),
            carouselButton(
                isActive: _activeButton == 3 ? true : false,
                onPressed: () => plop(3, SearchAnnoncesDisplayState.IMMERSION),
                label: Strings.immersionButton),
            _horizontalSeparator(),
            carouselButton(
                isActive: _activeButton == 4 ? true : false,
                onPressed: () => plop(4, SearchAnnoncesDisplayState.CIVIL_SERVICE),
                label: Strings.serviceCiviqueButton),
          ]),
        ),
        _verticalSeparator(),
        if (_annonceDisplayState == SearchAnnoncesDisplayState.IMMERSION) _immersionLabel(),
        Text(Strings.keyWordsTitle, style: TextStyles.textLgMedium),
        _verticalSeparator(),
        _keywordTextFormField(),
        _verticalSeparator(),
        Text(Strings.jobLocationTitle, style: TextStyles.textLgMedium),
        _verticalSeparator(),
        _autocomplete(viewModel),
        _verticalSeparator(),
        Center(
          child: primaryActionButton(
              onPressed: _isLoading(viewModel)
                  ? null
                  : () {
                      _searchingRequest(viewModel);
                      _dismissKeyboard(context);
                    },
              label: Strings.searchButton),
        ),
        _verticalSeparator(),
        if (viewModel.displayState == OffreEmploiSearchDisplayState.SHOW_ERROR ||
            viewModel.displayState == OffreEmploiSearchDisplayState.SHOW_EMPTY_ERROR)
          _errorTextField(viewModel),
      ],
    );
  }

  Widget _immersionLabel() {
    return Column(
      children: [
        Text(Strings.immersionLabel, style: TextStyles.textSmMedium()),
        _verticalSeparator(),
      ],
    );
  }

  void plop(int index, SearchAnnoncesDisplayState state) {
    _setDisplayState(state);
    setState(() {
      _activeButton = index;
    });
  }

  SizedBox _verticalSeparator() => SizedBox(height: 24);

  SizedBox _horizontalSeparator() => SizedBox(width: 12);

  _setDisplayState(SearchAnnoncesDisplayState state) => _annonceDisplayState = state;

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
          _deleteSelectedLocationOnTextDeletion(newLocationQuery);
          if (newLocationQuery != _currentLocationQuery) {
            viewModel.onInputLocation(newLocationQuery);
            _currentLocationQuery = newLocationQuery;
          }
          return [_fakeLocationRequiredByAutocompleteToCallOptionsViewBuilderMethod()];
        },
        onSelected: (locationViewModel) {
          _selectedLocationViewModel = locationViewModel;
          _dismissKeyboard(context);
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
                    itemCount: viewModel.locations.length + _fakeItemsAddedToLeverageAdditionalScrollInAutocomplete,
                    itemBuilder: (BuildContext context, int index) => _listTile(viewModel, onSelected, index),
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
              decoration: _inputDecoration(Strings.jobLocationHint),
              focusNode: focusNode,
            ),
          );
        },
      ),
    );
  }

  void _dismissKeyboard(BuildContext context) => FocusScope.of(context).unfocus();

  void _putBackLastLocationSetOnFocusLost(bool hasFocus, TextEditingController textEditingController) {
    final selectedLocationViewModel = _selectedLocationViewModel;
    if (!hasFocus && selectedLocationViewModel != null) {
      textEditingController.text = selectedLocationViewModel.title;
    }
  }

  void _deleteSelectedLocationOnTextDeletion(String newLocationQuery) {
    if (newLocationQuery.isEmpty) _selectedLocationViewModel = null;
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
    viewModel.searchingRequest(_keyWord, _selectedLocationViewModel?.location);
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

  Widget _listTile(
    OffreEmploiSearchViewModel viewModel,
    AutocompleteOnSelected<LocationViewModel> onSelected,
    int index,
  ) {
    if (index + 1 > viewModel.locations.length) {
      return _fakeListTileToLeverageAdditionalScrollInAutocompleteWidget();
    } else {
      return _realListTile(viewModel, onSelected, index);
    }
  }

  Widget _fakeListTileToLeverageAdditionalScrollInAutocompleteWidget() {
    return Container(height: 48, color: AppColors.lightBlue);
  }

  Widget _realListTile(
      OffreEmploiSearchViewModel viewModel, AutocompleteOnSelected<LocationViewModel> onSelected, int index) {
    final LocationViewModel locationViewModel = viewModel.locations.elementAt(index);
    return GestureDetector(
      onTap: () => onSelected(locationViewModel),
      child: ListTile(
        title: Text(locationViewModel.title, style: const TextStyle(color: AppColors.nightBlue)),
      ),
    );
  }
}
