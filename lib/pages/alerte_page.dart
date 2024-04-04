import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/alerte/get/alerte_get_action.dart';
import 'package:pass_emploi_app/features/alerte/list/alerte_list_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_actions.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/models/alerte/immersion_alerte.dart';
import 'package:pass_emploi_app/models/alerte/offre_emploi_alerte.dart';
import 'package:pass_emploi_app/models/alerte/service_civique_alerte.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/pages/offre_filters_bottom_sheet.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_emploi_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_immersion_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_service_civique_page.dart';
import 'package:pass_emploi_app/pages/suggestions_recherche/suggestions_recherche_list_page.dart';
import 'package:pass_emploi_app/presentation/alerte/alerte_list_view_model.dart';
import 'package:pass_emploi_app/presentation/alerte/alerte_navigation_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
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
import 'package:pass_emploi_app/widgets/dialogs/alerte_delete_dialog.dart';
import 'package:pass_emploi_app/widgets/illustration/empty_state_placeholder.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';
import 'package:pass_emploi_app/widgets/voir_suggestions_recherche_card.dart';

class AlertePage extends StatefulWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => AlertePage());
  }

  @override
  State<AlertePage> createState() => _AlertePageState();
}

class _AlertePageState extends State<AlertePage> {
  OffreFilter _selectedFilter = OffreFilter.tous;
  bool _shouldNavigate = true;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.alerteList,
      child: StoreConnector<AppState, AlerteListViewModel>(
        onInit: (store) {
          store.dispatch(AlerteListRequestAction());
          store.dispatch(SuggestionsRechercheRequestAction());
          final deepLink = store.getDeepLinkAs<AlerteDeepLink>();
          if (deepLink != null) {
            store.dispatch(FetchAlerteResultsFromIdAction(deepLink.idAlerte));
          }
        },
        onWillChange: (_, newVM) => _onWillChange(_, newVM),
        builder: (context, viewModel) => _body(viewModel),
        converter: (store) => AlerteListViewModel.createFromStore(store),
        distinct: true,
      ),
    );
  }

  void _onWillChange(AlerteListViewModel? _, AlerteListViewModel? newViewModel) {
    if (!_shouldNavigate || newViewModel == null) return;
    final page = switch (newViewModel.searchNavigationState) {
      AlerteNavigationState.OFFRE_EMPLOI => RechercheOffreEmploiPage(onlyAlternance: false),
      AlerteNavigationState.OFFRE_ALTERNANCE => RechercheOffreEmploiPage(onlyAlternance: true),
      AlerteNavigationState.OFFRE_IMMERSION => RechercheOffreImmersionPage(),
      AlerteNavigationState.SERVICE_CIVIQUE => RechercheOffreServiceCiviquePage(),
      AlerteNavigationState.NONE => null,
    };
    if (page != null) _goToPage(page);
  }

  Future<bool> _goToPage(Widget page) {
    _shouldNavigate = false;
    return Navigator.push(context, MaterialPageRoute(builder: (_) => page)).then((_) => _shouldNavigate = true);
  }

  Widget _body(AlerteListViewModel viewModel) {
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.mesAlertesPageTitle),
      backgroundColor: AppColors.grey100,
      body: _content(viewModel),
      floatingActionButton: _floatingActionButton(context, viewModel),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _floatingActionButton(BuildContext context, AlerteListViewModel viewModel) {
    if (viewModel.displayState != DisplayState.CONTENT) return SizedBox();

    if (_selectedFilter == OffreFilter.tous && viewModel.alertes.isEmpty) {
      return PrimaryActionButton(label: Strings.alertesListEmptyButton, onPressed: () => _goToRecherche(context));
    }

    return FiltreButton(
      onPressed: () async {
        OffreFiltersBottomSheet.show(context, _selectedFilter).then((result) {
          if (result != null) _filterSelected(result);
        });
      },
    );
  }

  Widget _content(AlerteListViewModel viewModel) {
    final displayState = viewModel.displayState;
    return AnimatedSwitcher(
      duration: AnimationDurations.fast,
      child: switch (displayState) {
        DisplayState.LOADING => _AlerteLoading(),
        DisplayState.FAILURE => Retry(Strings.alerteGetError, () => viewModel.onRetry()),
        _ => _alertes(viewModel),
      },
    );
  }

  Widget _alertes(AlerteListViewModel viewModel) {
    final List<Alerte> alertes = viewModel.getAlertesFiltered(_selectedFilter);
    if (alertes.isEmpty) return _noAlerte();
    return ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: Margins.spacing_base),
        padding: EdgeInsets.all(Margins.spacing_base),
        itemCount: alertes.length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          final alerte = alertes[index];
          return Column(
            children: [
              Builder(builder: (context) {
                return switch (alerte) {
                  OffreEmploiAlerte() => _buildEmploiCard(context, alerte, viewModel),
                  ImmersionAlerte() => _buildImmersionCard(context, alerte, viewModel),
                  ServiceCiviqueAlerte() => _buildServiceCiviqueCard(context, alerte, viewModel),
                  _ => SizedBox.shrink(),
                };
              }),
              if (index == alertes.length - 1) ...[
                SizedBox(height: Margins.spacing_base),
                VoirSuggestionsRechercheCard(onTapShowSuggestions: _onTapShowSuggestions),
                SizedBox(height: Margins.spacing_huge),
              ],
            ],
          );
        });
  }

  Widget _noAlerte() {
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

  Widget _buildEmploiCard(BuildContext context, OffreEmploiAlerte offreEmploi, AlerteListViewModel viewModel) {
    final type = offreEmploi.onlyAlternance ? AlerteType.ALTERNANCE : AlerteType.EMPLOI;
    return FavoriCard.deletable(
      offreType: offreEmploi.onlyAlternance ? OffreType.alternance : OffreType.emploi,
      onTap: () => viewModel.offreEmploiSelected(offreEmploi),
      onDelete: () => _showDeleteDialog(viewModel, offreEmploi.id, type),
      title: offreEmploi.title,
      place: offreEmploi.location?.libelle,
    );
  }

  Widget _buildImmersionCard(
    BuildContext context,
    ImmersionAlerte alertesImmersion,
    AlerteListViewModel viewModel,
  ) {
    return FavoriCard.deletable(
      offreType: OffreType.immersion,
      onTap: () => viewModel.offreImmersionSelected(alertesImmersion),
      onDelete: () => _showDeleteDialog(viewModel, alertesImmersion.id, AlerteType.IMMERSION),
      title: alertesImmersion.title,
      place: alertesImmersion.ville,
    );
  }

  Widget _buildServiceCiviqueCard(
    BuildContext context,
    ServiceCiviqueAlerte alertesServiceCivique,
    AlerteListViewModel viewModel,
  ) {
    return FavoriCard.deletable(
      offreType: OffreType.serviceCivique,
      onTap: () => viewModel.offreServiceCiviqueSelected(alertesServiceCivique),
      onDelete: () => _showDeleteDialog(viewModel, alertesServiceCivique.id, AlerteType.SERVICE_CIVIQUE),
      title: alertesServiceCivique.titre,
      place: alertesServiceCivique.ville?.isNotEmpty == true ? alertesServiceCivique.ville : null,
    );
  }

  void _goToRecherche(BuildContext context) {
    Navigator.of(context).pop();
    StoreProvider.of<AppState>(context).dispatch(
      HandleDeepLinkAction(
        RechercheDeepLink(),
        DeepLinkOrigin.inAppNavigation,
      ),
    );
  }

  void _onTapShowSuggestions() {
    PassEmploiMatomoTracker.instance.trackScreen(AnalyticsScreenNames.alerteSuggestionsListe);
    Navigator.push(context, SuggestionsRechercheListPage.materialPageRoute());
  }

  void _showDeleteDialog(AlerteListViewModel viewModel, String alerteId, AlerteType type) {
    showDialog(
      context: context,
      builder: (_) => AlerteDeleteDialog(alerteId, type),
    ).then((result) {
      if (result == true) showSnackBarWithSuccess(context, Strings.alerteDeleteSuccess);
    });
  }

  void _filterSelected(OffreFilter filter) {
    setState(() => _selectedFilter = filter);
    _scrollController.jumpTo(0);
    PassEmploiMatomoTracker.instance.trackScreen(switch (filter) {
      OffreFilter.tous => AnalyticsScreenNames.alerteList,
      OffreFilter.emploi => AnalyticsScreenNames.alerteListFilterEmploi,
      OffreFilter.alternance => AnalyticsScreenNames.alerteListFilterAlternance,
      OffreFilter.immersion => AnalyticsScreenNames.alerteListFilterImmersion,
      OffreFilter.serviceCivique => AnalyticsScreenNames.alerteListFilterServiceCivique
    });
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

class _AlerteLoading extends StatelessWidget {
  const _AlerteLoading();

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
