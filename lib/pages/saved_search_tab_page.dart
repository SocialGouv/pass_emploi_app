import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/saved_search/get/saved_search_get_action.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_actions.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/models/solution_type.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_emploi_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_immersion_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_service_civique_page.dart';
import 'package:pass_emploi_app/pages/suggestions_recherche/suggestions_recherche_list_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_list_view_model.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_navigation_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/carousel_button.dart';
import 'package:pass_emploi_app/widgets/cards/favori_card.dart';
import 'package:pass_emploi_app/widgets/dialogs/saved_search_delete_dialog.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';
import 'package:pass_emploi_app/widgets/voir_suggestions_recherche_card.dart';

enum IndexOf { OFFRES_EMPLOI, ALTERNANCE, SERVICE_CIVIQUE, IMMERSION }

class SavedSearchTabPage extends StatefulWidget {
  @override
  State<SavedSearchTabPage> createState() => _SavedSearchTabPageState();
}

class _SavedSearchTabPageState extends State<SavedSearchTabPage> {
  IndexOf _selectedIndex = IndexOf.OFFRES_EMPLOI;
  bool _shouldNavigate = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SavedSearchListViewModel>(
      onInit: (store) {
        store.dispatch(SavedSearchListRequestAction());
        store.dispatch(SuggestionsRechercheRequestAction());
        final DeepLinkState state = store.state.deepLinkState;
        if (state is SavedSearchDeepLinkState) store.dispatch(SavedSearchGetAction(state.idSavedSearch));
      },
      onWillChange: (_, newVM) => _onWillChange(_, newVM),
      builder: (context, viewModel) => _scrollView(viewModel),
      converter: (store) => SavedSearchListViewModel.createFromStore(store),
      distinct: true,
    );
  }

  void _onWillChange(SavedSearchListViewModel? _, SavedSearchListViewModel? newViewModel) {
    if (!_shouldNavigate || newViewModel == null) return;
    switch (newViewModel.searchNavigationState) {
      case SavedSearchNavigationState.OFFRE_EMPLOI:
        _goToPage(IndexOf.OFFRES_EMPLOI, RechercheOffreEmploiPage(onlyAlternance: false));
        break;
      case SavedSearchNavigationState.OFFRE_ALTERNANCE:
        _goToPage(IndexOf.ALTERNANCE, RechercheOffreEmploiPage(onlyAlternance: true));
        break;
      case SavedSearchNavigationState.OFFRE_IMMERSION:
        _goToPage(IndexOf.IMMERSION, RechercheOffreImmersionPage());
        break;
      case SavedSearchNavigationState.SERVICE_CIVIQUE:
        _goToPage(IndexOf.SERVICE_CIVIQUE, RechercheOffreServiceCiviquePage());
        break;
      case SavedSearchNavigationState.NONE:
        break;
    }
  }

  Future<bool> _goToPage(IndexOf newIndex, Widget page) {
    _shouldNavigate = false;
    _updateIndex(newIndex, true);
    return Navigator.push(context, MaterialPageRoute(builder: (_) => page)).then((_) => _shouldNavigate = true);
  }

  Widget _scrollView(SavedSearchListViewModel viewModel) {
    return Column(
      children: [
        SizedBox(height: Margins.spacing_m),
        _carousel(),
        Expanded(child: _content(viewModel)),
      ],
    );
  }

  Widget _carousel() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Row(
        children: [
          SizedBox(width: Margins.spacing_base),
          CarouselButton(
            isActive: _selectedIndex == IndexOf.OFFRES_EMPLOI,
            onPressed: () => _updateIndex(IndexOf.OFFRES_EMPLOI),
            label: Strings.offresEmploiButton,
          ),
          SizedBox(width: Margins.spacing_base),
          CarouselButton(
            isActive: _selectedIndex == IndexOf.ALTERNANCE,
            onPressed: () => _updateIndex(IndexOf.ALTERNANCE),
            label: Strings.alternanceButton,
          ),
          SizedBox(width: Margins.spacing_base),
          CarouselButton(
            isActive: _selectedIndex == IndexOf.SERVICE_CIVIQUE,
            onPressed: () => _updateIndex(IndexOf.SERVICE_CIVIQUE),
            label: Strings.serviceCiviqueButton,
          ),
          SizedBox(width: Margins.spacing_base),
          CarouselButton(
            isActive: _selectedIndex == IndexOf.IMMERSION,
            onPressed: () => _updateIndex(IndexOf.IMMERSION),
            label: Strings.immersionButton,
          ),
          SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _content(SavedSearchListViewModel viewModel) {
    if (viewModel.displayState == DisplayState.LOADING) {
      return Center(child: CircularProgressIndicator(color: AppColors.nightBlue));
    }
    if (viewModel.displayState == DisplayState.FAILURE) {
      return Center(child: Retry(Strings.savedSearchGetError, () => viewModel.onRetry()));
    }
    switch (_selectedIndex) {
      case IndexOf.SERVICE_CIVIQUE:
        PassEmploiMatomoTracker.instance.trackScreen(AnalyticsScreenNames.savedSearchServiceCiviqueList);
        return _getSavedSearchServiceCivique(viewModel);
      case IndexOf.OFFRES_EMPLOI:
        PassEmploiMatomoTracker.instance.trackScreen(AnalyticsScreenNames.savedSearchEmploiList);
        return _getSavedSearchOffreEmploi(viewModel, false);
      case IndexOf.ALTERNANCE:
        PassEmploiMatomoTracker.instance.trackScreen(AnalyticsScreenNames.savedSearchAlternanceList);
        return _getSavedSearchOffreEmploi(viewModel, true);
      default:
        PassEmploiMatomoTracker.instance.trackScreen(AnalyticsScreenNames.savedSearchEmploiList);
        return _getSavedSearchImmersions(viewModel);
    }
  }

  void _updateIndex(IndexOf index, [bool withScroll = false]) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
        if (withScroll) {
          _scrollController.jumpTo(_selectedIndex.index * 100);
        }
      });
    }
  }

  final int _oneMoreIndexForSuggestionsRechercheCard = 1;

  Widget _getSavedSearchOffreEmploi(SavedSearchListViewModel viewModel, bool isAlternance) {
    final offreEmplois = viewModel.getOffresEmploi(isAlternance);
    if (offreEmplois.isEmpty) return _noSavedSearch();

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: offreEmplois.length + _oneMoreIndexForSuggestionsRechercheCard,
      itemBuilder: (context, position) {
        if (position == 0) return _suggestionsRechercheCard();
        position -= 1;
        final double topPadding = (position == 0) ? Margins.spacing_m : 0;
        return Padding(
          padding: EdgeInsets.fromLTRB(Margins.spacing_base, topPadding, Margins.spacing_base, Margins.spacing_base),
          child: _buildCard(context, offreEmplois[position], viewModel),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, OffreEmploiSavedSearch offreEmploi, SavedSearchListViewModel viewModel) {
    final type = offreEmploi.onlyAlternance ? SavedSearchType.ALTERNANCE : SavedSearchType.EMPLOI;
    return FavoriCard.deletable(
      solutionType: offreEmploi.onlyAlternance ? SolutionType.Alternance : SolutionType.OffreEmploi,
      onTap: () => viewModel.offreEmploiSelected(offreEmploi),
      onDelete: () => _showDeleteDialog(viewModel, offreEmploi.id, type),
      title: offreEmploi.title,
      place: offreEmploi.location?.libelle,
      bottomTip: Strings.voirResultatsSuggestion,
    );
  }

  Widget _getSavedSearchImmersions(SavedSearchListViewModel viewModel) {
    final savedSearchsImmersion = viewModel.getImmersions();
    if (savedSearchsImmersion.isEmpty) return _noSavedSearch();

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: savedSearchsImmersion.length + _oneMoreIndexForSuggestionsRechercheCard,
      itemBuilder: (context, position) {
        if (position == 0) return _suggestionsRechercheCard();
        position -= 1;
        final double topPadding = (position == 0) ? Margins.spacing_m : 0;
        return Padding(
          padding: EdgeInsets.fromLTRB(Margins.spacing_base, topPadding, Margins.spacing_base, Margins.spacing_base),
          child: _buildImmersionCard(context, savedSearchsImmersion[position], viewModel),
        );
      },
    );
  }

  Widget _getSavedSearchServiceCivique(SavedSearchListViewModel viewModel) {
    final savedSearchsServiceCivique = viewModel.getServiceCivique();
    if (savedSearchsServiceCivique.isEmpty) return _noSavedSearch();

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: savedSearchsServiceCivique.length + _oneMoreIndexForSuggestionsRechercheCard,
      itemBuilder: (context, position) {
        if (position == 0) return _suggestionsRechercheCard();
        position -= 1;
        final double topPadding = (position == 0) ? Margins.spacing_m : 0;
        return Padding(
          padding: EdgeInsets.fromLTRB(Margins.spacing_base, topPadding, Margins.spacing_base, Margins.spacing_base),
          child: _buildServiceCiviqueCard(context, savedSearchsServiceCivique[position], viewModel),
        );
      },
    );
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
      onTapShowSuggestions: () => {Navigator.push(context, SuggestionsRechercheListPage.materialPageRoute())},
    );
  }

  Widget _buildImmersionCard(
    BuildContext context,
    ImmersionSavedSearch savedSearchsImmersion,
    SavedSearchListViewModel viewModel,
  ) {
    return FavoriCard.deletable(
      solutionType: SolutionType.Immersion,
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
      solutionType: SolutionType.ServiceCivique,
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
}
