import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/saved_search/get/saved_search_get_action.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_actions.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/pages/offre_filters_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_emploi_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_immersion_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_service_civique_page.dart';
import 'package:pass_emploi_app/pages/suggestions_recherche/suggestions_recherche_list_page.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_list_view_model.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_navigation_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/filtre_button.dart';
import 'package:pass_emploi_app/widgets/cards/favori_card.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/dialogs/saved_search_delete_dialog.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';
import 'package:pass_emploi_app/widgets/voir_suggestions_recherche_card.dart';

class SavedSearchPage extends StatefulWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => SavedSearchPage());
  }

  @override
  State<SavedSearchPage> createState() => _SavedSearchPageState();
}

class _SavedSearchPageState extends State<SavedSearchPage> {
  OffreFilter _selectedFilter = OffreFilter.tous;
  bool _shouldNavigate = true;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.mesAlertesTabTitle),
      body: Tracker(
        tracking: AnalyticsScreenNames.savedSearchList,
        child: StoreConnector<AppState, SavedSearchListViewModel>(
          onInit: (store) {
            store.dispatch(SavedSearchListRequestAction());
            store.dispatch(SuggestionsRechercheRequestAction());
            final DeepLinkState state = store.state.deepLinkState;
            if (state is SavedSearchDeepLinkState) {
              store.dispatch(FetchSavedSearchResultsFromIdAction(state.idSavedSearch));
            }
          },
          onWillChange: (_, newVM) => _onWillChange(_, newVM),
          builder: (context, viewModel) => _body(viewModel),
          converter: (store) => SavedSearchListViewModel.createFromStore(store),
          distinct: true,
        ),
      ),
    );
  }

  void _onWillChange(SavedSearchListViewModel? _, SavedSearchListViewModel? newViewModel) {
    if (!_shouldNavigate || newViewModel == null) return;
    switch (newViewModel.searchNavigationState) {
      case SavedSearchNavigationState.OFFRE_EMPLOI:
        _goToPage(RechercheOffreEmploiPage(onlyAlternance: false));
        break;
      case SavedSearchNavigationState.OFFRE_ALTERNANCE:
        _goToPage(RechercheOffreEmploiPage(onlyAlternance: true));
        break;
      case SavedSearchNavigationState.OFFRE_IMMERSION:
        _goToPage(RechercheOffreImmersionPage());
        break;
      case SavedSearchNavigationState.SERVICE_CIVIQUE:
        _goToPage(RechercheOffreServiceCiviquePage());
        break;
      case SavedSearchNavigationState.NONE:
        break;
    }
  }

  Future<bool> _goToPage(Widget page) {
    _shouldNavigate = false;
    return Navigator.push(context, MaterialPageRoute(builder: (_) => page)).then((_) => _shouldNavigate = true);
  }

  Widget _body(SavedSearchListViewModel viewModel) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Column(
        children: [
          Expanded(child: _content(viewModel)),
        ],
      ),
      floatingActionButton: FiltreButton.primary(
        onPressed: () async {
          Navigator.push(context, OffreFiltersPage.materialPageRoute(initialFilter: _selectedFilter)).then((result) {
            if (result != null) _filterSelected(result);
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _content(SavedSearchListViewModel viewModel) {
    if (viewModel.displayState.isLoading()) return Center(child: CircularProgressIndicator());
    if (viewModel.displayState.isFailure()) {
      return Center(child: Retry(Strings.savedSearchGetError, () => viewModel.onRetry()));
    }
    return _savedSearches(viewModel);
  }

  Widget _buildCard(BuildContext context, OffreEmploiSavedSearch offreEmploi, SavedSearchListViewModel viewModel) {
    final type = offreEmploi.onlyAlternance ? SavedSearchType.ALTERNANCE : SavedSearchType.EMPLOI;
    return FavoriCard.deletable(
      offreType: offreEmploi.onlyAlternance ? OffreType.alternance : OffreType.emploi,
      onTap: () => viewModel.offreEmploiSelected(offreEmploi),
      onDelete: () => _showDeleteDialog(viewModel, offreEmploi.id, type),
      title: offreEmploi.title,
      place: offreEmploi.location?.libelle,
      bottomTip: Strings.voirResultatsSuggestion,
    );
  }

  Widget _savedSearches(SavedSearchListViewModel viewModel) {
    final List<SavedSearch> savedSearches = _getSavedSearchesFiltered(viewModel);
    if (savedSearches.isEmpty) return _noSavedSearch();
    return ListView.builder(
        itemCount: savedSearches.length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          final savedSearch = savedSearches[index];
          return Column(
            children: [
              if (index == 0) ...[
                _suggestionsRechercheCard(),
                SizedBox(height: Margins.spacing_base),
              ],
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Margins.spacing_base, vertical: Margins.spacing_s),
                child: Builder(builder: (context) {
                  if (savedSearch is OffreEmploiSavedSearch) {
                    return _buildCard(context, savedSearch, viewModel);
                  } else if (savedSearch is ImmersionSavedSearch) {
                    return _buildImmersionCard(context, savedSearch, viewModel);
                  } else if (savedSearch is ServiceCiviqueSavedSearch) {
                    return _buildServiceCiviqueCard(context, savedSearch, viewModel);
                  } else {
                    return Container();
                  }
                }),
              ),
              if (index == savedSearches.length - 1) SizedBox(height: Margins.spacing_huge),
            ],
          );
        });
  }

  List<SavedSearch> _getSavedSearchesFiltered(SavedSearchListViewModel viewModel) {
    switch (_selectedFilter) {
      case OffreFilter.immersion:
        return viewModel.getImmersions();
      case OffreFilter.serviceCivique:
        return viewModel.getServiceCivique();
      case OffreFilter.emploi:
        return viewModel.getOffresEmploi();
      case OffreFilter.alternance:
        return viewModel.getAlternance();
      default:
        return viewModel.savedSearches;
    }
  }

  Widget _noSavedSearch() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _suggestionsRechercheCard(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Margins.spacing_l),
            child: Center(child: Text(Strings.noSavedSearchYet, style: TextStyles.textSRegular())),
          ),
        ],
      ),
    );
  }

  Widget _suggestionsRechercheCard() {
    return VoirSuggestionsRechercheCard(
      padding: const EdgeInsets.fromLTRB(Margins.spacing_base, Margins.spacing_m, Margins.spacing_base, 0),
      onTapShowSuggestions: () {
        PassEmploiMatomoTracker.instance.trackScreen(AnalyticsScreenNames.savedSearchSuggestionsListe);
        Navigator.push(context, SuggestionsRechercheListPage.materialPageRoute());
      },
    );
  }

  Widget _buildImmersionCard(
    BuildContext context,
    ImmersionSavedSearch savedSearchsImmersion,
    SavedSearchListViewModel viewModel,
  ) {
    return FavoriCard.deletable(
      offreType: OffreType.immersion,
      onTap: () => viewModel.offreImmersionSelected(savedSearchsImmersion),
      onDelete: () => _showDeleteDialog(viewModel, savedSearchsImmersion.id, SavedSearchType.IMMERSION),
      title: savedSearchsImmersion.title,
      place: savedSearchsImmersion.ville,
      bottomTip: Strings.voirResultatsSuggestion,
    );
  }

  Widget _buildServiceCiviqueCard(
    BuildContext context,
    ServiceCiviqueSavedSearch savedSearchsServiceCivique,
    SavedSearchListViewModel viewModel,
  ) {
    return FavoriCard.deletable(
      offreType: OffreType.serviceCivique,
      onTap: () => viewModel.offreServiceCiviqueSelected(savedSearchsServiceCivique),
      onDelete: () => _showDeleteDialog(viewModel, savedSearchsServiceCivique.id, SavedSearchType.SERVICE_CIVIQUE),
      title: savedSearchsServiceCivique.titre,
      place: savedSearchsServiceCivique.ville?.isNotEmpty == true ? savedSearchsServiceCivique.ville : null,
      bottomTip: Strings.voirResultatsSuggestion,
    );
  }

  void _showDeleteDialog(SavedSearchListViewModel viewModel, String savedSearchId, SavedSearchType type) {
    showDialog(
      context: context,
      builder: (_) => SavedSearchDeleteDialog(savedSearchId, type),
    ).then((result) {
      if (result == true) showSuccessfulSnackBar(context, Strings.savedSearchDeleteSuccess);
    });
  }

  void _filterSelected(OffreFilter filter) {
    setState(() => _selectedFilter = filter);
    _scrollController.jumpTo(0);
    final String tracking;
    switch (filter) {
      case OffreFilter.tous:
        tracking = AnalyticsScreenNames.savedSearchList;
        break;
      case OffreFilter.emploi:
        tracking = AnalyticsScreenNames.savedSearchListFilterEmploi;
        break;
      case OffreFilter.alternance:
        tracking = AnalyticsScreenNames.savedSearchListFilterAlternance;
        break;
      case OffreFilter.immersion:
        tracking = AnalyticsScreenNames.savedSearchListFilterImmersion;
        break;
      case OffreFilter.serviceCivique:
        tracking = AnalyticsScreenNames.savedSearchListFilterServiceCivique;
        break;
    }
    PassEmploiMatomoTracker.instance.trackScreen(tracking);
  }
}
