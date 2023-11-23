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
import 'package:pass_emploi_app/pages/offre_filters_bottom_sheet.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_emploi_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_immersion_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_service_civique_page.dart';
import 'package:pass_emploi_app/pages/suggestions_recherche/suggestions_recherche_list_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_list_view_model.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_navigation_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/utils/store_extensions.dart';
import 'package:pass_emploi_app/widgets/animated_list_loader.dart';
import 'package:pass_emploi_app/widgets/buttons/filtre_button.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/favori_card.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/dialogs/saved_search_delete_dialog.dart';
import 'package:pass_emploi_app/widgets/illustration/empty_state_placeholder.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';
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
    final page = switch (newViewModel.searchNavigationState) {
      SavedSearchNavigationState.OFFRE_EMPLOI => RechercheOffreEmploiPage(onlyAlternance: false),
      SavedSearchNavigationState.OFFRE_ALTERNANCE => RechercheOffreEmploiPage(onlyAlternance: true),
      SavedSearchNavigationState.OFFRE_IMMERSION => RechercheOffreImmersionPage(),
      SavedSearchNavigationState.SERVICE_CIVIQUE => RechercheOffreServiceCiviquePage(),
      SavedSearchNavigationState.NONE => null,
    };
    if (page != null) _goToPage(page);
  }

  Future<bool> _goToPage(Widget page) {
    _shouldNavigate = false;
    return Navigator.push(context, MaterialPageRoute(builder: (_) => page)).then((_) => _shouldNavigate = true);
  }

  Widget _body(SavedSearchListViewModel viewModel) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: _content(viewModel),
      floatingActionButton: _floatingActionButton(context, viewModel),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget? _floatingActionButton(BuildContext context, SavedSearchListViewModel viewModel) {
    if (viewModel.displayState != DisplayState.CONTENT) return null;

    if (_selectedFilter == OffreFilter.tous && viewModel.savedSearches.isEmpty) {
      return PrimaryActionButton(label: Strings.alertesListEmptyButton, onPressed: () => _goToRecherche(context));
    }

    return FiltreButton.primary(
      onPressed: () async {
        OffreFiltersBottomSheet.show(context, _selectedFilter).then((result) {
          if (result != null) _filterSelected(result);
        });
      },
    );
  }

  Widget _content(SavedSearchListViewModel viewModel) {
    final displayState = viewModel.displayState;
    return AnimatedSwitcher(
      duration: AnimationDurations.fast,
      child: switch (displayState) {
        DisplayState.LOADING => _SavedSearchLoading(),
        DisplayState.FAILURE => Center(child: Retry(Strings.savedSearchGetError, () => viewModel.onRetry())),
        _ => _savedSearches(viewModel),
      },
    );
  }

  Widget _savedSearches(SavedSearchListViewModel viewModel) {
    final List<SavedSearch> savedSearches = _getSavedSearchesFiltered(viewModel);
    if (savedSearches.isEmpty) return _noSavedSearch();
    return ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: Margins.spacing_base),
        padding: EdgeInsets.all(Margins.spacing_base),
        itemCount: savedSearches.length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          final savedSearch = savedSearches[index];
          return Column(
            children: [
              Builder(builder: (context) {
                return switch (savedSearch) {
                  OffreEmploiSavedSearch() => _buildEmploiCard(context, savedSearch, viewModel),
                  ImmersionSavedSearch() => _buildImmersionCard(context, savedSearch, viewModel),
                  ServiceCiviqueSavedSearch() => _buildServiceCiviqueCard(context, savedSearch, viewModel),
                  _ => SizedBox.shrink(),
                };
              }),
              if (index == savedSearches.length - 1) ...[
                SizedBox(height: Margins.spacing_base),
                VoirSuggestionsRechercheCard(onTapShowSuggestions: _onTapShowSuggestions),
                SizedBox(height: Margins.spacing_huge),
              ],
            ],
          );
        });
  }

  List<SavedSearch> _getSavedSearchesFiltered(SavedSearchListViewModel viewModel) {
    final savedSearches = switch (_selectedFilter) {
      OffreFilter.immersion => viewModel.getAlternance(),
      OffreFilter.serviceCivique => viewModel.getImmersions(),
      OffreFilter.emploi => viewModel.getAlternance(),
      OffreFilter.alternance => viewModel.getAlternance(),
      OffreFilter.tous => viewModel.getAlternance(),
    };
    return savedSearches as List<SavedSearch>;
  }

  Widget _noSavedSearch() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(Margins.spacing_base),
            child: VoirSuggestionsRechercheCard(onTapShowSuggestions: _onTapShowSuggestions),
          ),
          SizedBox(height: Margins.spacing_base),
          _selectedFilter == OffreFilter.tous
              ? _EmptyListPlaceholder.noFavori()
              : _EmptyListPlaceholder.noFavoriFiltered(),
          SizedBox(height: Margins.spacing_huge),
        ],
      ),
    );
  }

  Widget _buildEmploiCard(
      BuildContext context, OffreEmploiSavedSearch offreEmploi, SavedSearchListViewModel viewModel) {
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

  void _goToRecherche(BuildContext context) {
    Navigator.of(context).pop();
    StoreProvider.of<AppState>(context).dispatchRechercheDeeplink();
  }

  void _onTapShowSuggestions() {
    PassEmploiMatomoTracker.instance.trackScreen(AnalyticsScreenNames.savedSearchSuggestionsListe);
    Navigator.push(context, SuggestionsRechercheListPage.materialPageRoute());
  }

  void _showDeleteDialog(SavedSearchListViewModel viewModel, String savedSearchId, SavedSearchType type) {
    showDialog(
      context: context,
      builder: (_) => SavedSearchDeleteDialog(savedSearchId, type),
    ).then((result) {
      if (result == true) showSnackBarWithSuccess(context, Strings.savedSearchDeleteSuccess);
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

class _EmptyListPlaceholder extends StatelessWidget {
  final String title;
  final String subtitle;

  _EmptyListPlaceholder({required this.title, required this.subtitle});

  factory _EmptyListPlaceholder.noFavori() {
    return _EmptyListPlaceholder(
      title: Strings.alertesListEmptyTitle,
      subtitle: Strings.alertesListEmptySubtitle,
    );
  }

  factory _EmptyListPlaceholder.noFavoriFiltered() {
    return _EmptyListPlaceholder(
      title: Strings.alertesFilteredListEmptyTitle,
      subtitle: Strings.alertesFilteredListEmptySubtitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EmptyStatePlaceholder(
        illustration: Illustration.grey(Icons.search, withWhiteBackground: true),
        title: title,
        subtitle: subtitle,
      ),
    );
  }
}

class _SavedSearchLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final placeholders = _placeholders(screenWidth);
    return AnimatedListLoader(
      placeholders: placeholders,
    );
  }

  List<Widget> _placeholders(double screenWidth) => [
        AnimatedListLoader.placeholderBuilder(
          width: screenWidth,
          height: 170,
        ),
        SizedBox(height: Margins.spacing_base),
        AnimatedListLoader.placeholderBuilder(
          width: screenWidth,
          height: 170,
        ),
        SizedBox(height: Margins.spacing_base),
        AnimatedListLoader.placeholderBuilder(
          width: screenWidth,
          height: 170,
        ),
        SizedBox(height: Margins.spacing_base),
        AnimatedListLoader.placeholderBuilder(
          width: screenWidth,
          height: 170,
        ),
        SizedBox(height: Margins.spacing_base),
        AnimatedListLoader.placeholderBuilder(
          width: screenWidth,
          height: 170,
        ),
      ];
}
