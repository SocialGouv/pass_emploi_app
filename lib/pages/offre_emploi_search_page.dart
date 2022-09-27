import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/location/search_location_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/suggestions_recherche_actions.dart';
import 'package:pass_emploi_app/pages/offre_emploi_list_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_search_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/keyboard.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';
import 'package:pass_emploi_app/widgets/location_autocomplete.dart';
import 'package:pass_emploi_app/widgets/voir_suggestions_recherche_bandeau.dart';

class OffreEmploiSearchPage extends StatefulWidget {
  final bool onlyAlternance;

  OffreEmploiSearchPage({required this.onlyAlternance}) : super(key: ValueKey(onlyAlternance));

  @override
  State<OffreEmploiSearchPage> createState() => _OffreEmploiSearchPageState();
}

class _OffreEmploiSearchPageState extends State<OffreEmploiSearchPage> {
  LocationViewModel? _selectedLocationViewModel;
  var _keyWord = "";
  var _shouldNavigate = true;

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: widget.onlyAlternance ? AnalyticsScreenNames.alternanceResearch : AnalyticsScreenNames.emploiResearch,
      child: StoreConnector<AppState, OffreEmploiSearchViewModel>(
        onInit: (store) => store.dispatch(SuggestionsRechercheRequestAction()),
        converter: (store) => OffreEmploiSearchViewModel.create(store),
        onWillChange: (_, newViewModel) {
          if (newViewModel.displayState == DisplayState.CONTENT && _shouldNavigate) {
            _shouldNavigate = false;
            Navigator.push(context, OffreEmploiListPage.materialPageRoute(onlyAlternance: widget.onlyAlternance))
                .then((value) {
              _shouldNavigate = true;
            });
          }
        },
        distinct: true,
        builder: (context, viewModel) => _body(viewModel),
        onDispose: (store) => store.dispatch(SearchLocationResetAction()),
      ),
    );
  }

  Widget _body(OffreEmploiSearchViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: Margins.spacing_s),
          VoirSuggestionsRechercheBandeau(
            padding: const EdgeInsets.only(top: Margins.spacing_s, bottom: Margins.spacing_m),
          ),
          Text(Strings.keyWordsTitle, style: TextStyles.textBaseBold),
          Text(Strings.keyWordsTextHint, style: TextStyles.textSRegularWithColor(AppColors.contentColor)),
          SizedBox(height: Margins.spacing_base),
          _keywordTextFormField(),
          _separator(),
          Text(Strings.jobLocationTitle, style: TextStyles.textBaseBold),
          Text(Strings.jobLocationHint, style: TextStyles.textSRegularWithColor(AppColors.contentColor)),
          SizedBox(height: Margins.spacing_base),
          LocationAutocomplete(
            onInputLocation: (newLocationQuery) => viewModel.onInputLocation(newLocationQuery),
            onSelectLocationViewModel: (locationViewModel) => _selectedLocationViewModel = locationViewModel,
            locationViewModels: viewModel.locations,
            hint: Strings.jobLocationHint,
            getPreviouslySelectedTitle: () => _selectedLocationViewModel?.title,
            formKey: null,
            validator: (value) => null,
          ),
          _separator(),
          PrimaryActionButton(
            onPressed: _isLoading(viewModel) ? null : () => _onSearchButtonPressed(viewModel),
            label: Strings.searchButton,
          ),
          _separator(),
          if (_isError(viewModel)) ErrorText(viewModel.errorMessage),
        ],
      ),
    );
  }

  bool _isLoading(OffreEmploiSearchViewModel viewModel) => viewModel.displayState == DisplayState.LOADING;

  bool _isError(OffreEmploiSearchViewModel viewModel) => viewModel.displayState == DisplayState.FAILURE;

  SizedBox _separator() => SizedBox(height: Margins.spacing_m);

  TextFormField _keywordTextFormField() {
    return TextFormField(
      style: TextStyles.textBaseBold,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.done,
      decoration: _inputDecoration(),
      onChanged: (keyword) => _keyWord = keyword,
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.only(left: 24, top: 18, bottom: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppColors.contentColor, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppColors.primary, width: 1.0),
      ),
    );
  }

  void _onSearchButtonPressed(OffreEmploiSearchViewModel viewModel) {
    viewModel.onSearchingRequest(_keyWord, _selectedLocationViewModel?.location, widget.onlyAlternance);
    Keyboard.dismiss(context);
  }
}
