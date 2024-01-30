import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_state.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_actions.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/pages/immersion/immersion_details_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi/offre_emploi_details_page.dart';
import 'package:pass_emploi_app/pages/offre_filters_bottom_sheet.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/pages/service_civique/service_civique_detail_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/favori_list_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/animated_list_loader.dart';
import 'package:pass_emploi_app/widgets/buttons/filtre_button.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/favori_card.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';
import 'package:pass_emploi_app/widgets/illustration/empty_state_placeholder.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:redux/redux.dart';

class OffreFavorisPage extends StatefulWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => OffreFavorisPage());
  }

  @override
  State<OffreFavorisPage> createState() => _OffreFavorisPageState();
}

class _OffreFavorisPageState extends State<OffreFavorisPage> {
  OffreFilter _selectedFilter = OffreFilter.tous;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.mesFavorisTabTitle),
      body: Tracker(
        tracking: AnalyticsScreenNames.offreFavorisList,
        child: StoreConnector<AppState, FavoriListViewModel>(
          onInit: (store) => store.dispatch(FavoriListRequestAction()),
          converter: (store) => FavoriListViewModel.create(store),
          builder: _builder,
          distinct: true,
        ),
      ),
    );
  }

  Widget _builder(BuildContext context, FavoriListViewModel viewModel) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Center(child: _content(viewModel)),
      floatingActionButton: _floatingActionButton(context, viewModel),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _floatingActionButton(BuildContext context, FavoriListViewModel viewModel) {
    return switch (viewModel.displayState) {
      DisplayState.EMPTY => PrimaryActionButton(
          label: Strings.favorisListEmptyButton,
          onPressed: () => _goToRecherche(context),
        ),
      DisplayState.CONTENT => FiltreButton(
          onPressed: () async {
            OffreFiltersBottomSheet.show(context, _selectedFilter).then((result) {
              if (result != null) _filterSelected(result);
            });
          },
        ),
      _ => SizedBox(),
    };
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

  Widget _content(FavoriListViewModel viewModel) {
    final displayState = viewModel.displayState;
    return AnimatedSwitcher(
      duration: AnimationDurations.fast,
      child: switch (displayState) {
        DisplayState.LOADING => _OffreFavorisLoading(),
        DisplayState.FAILURE => Retry(Strings.favorisError, () => viewModel.onRetry()),
        DisplayState.EMPTY => _EmptyListPlaceholder.noFavori(),
        DisplayState.CONTENT => _favoris(viewModel),
      },
    );
  }

  Widget _favoris(FavoriListViewModel viewModel) {
    final favoris = _getFavorisFiltered(viewModel);
    if (favoris.isEmpty) return _EmptyListPlaceholder.noFavoriFiltered();
    return ListView.separated(
      padding: const EdgeInsets.only(
        left: Margins.spacing_base,
        top: Margins.spacing_base,
        right: Margins.spacing_base,
        bottom: Margins.spacing_huge,
      ),
      itemCount: favoris.length,
      itemBuilder: (context, index) {
        final favori = favoris[index];
        switch (favori.type) {
          case OffreType.emploi:
          case OffreType.alternance:
            return _buildOffreEmploiItem(context, favori);
          case OffreType.immersion:
            return _buildImmersionItem(context, favori);
          case OffreType.serviceCivique:
            return _buildServiceCiviqueItem(context, favori);
        }
      },
      separatorBuilder: (_, __) => SizedBox(height: Margins.spacing_base),
      controller: _scrollController,
    );
  }

  Widget _buildOffreEmploiItem(BuildContext context, Favori favori) {
    return _buildItem<OffreEmploi>(
      context: context,
      favori: favori,
      selectState: (store) => store.state.offreEmploiFavorisIdsState,
      onTap: () => Navigator.push(
        context,
        OffreEmploiDetailsPage.materialPageRoute(
          favori.id,
          fromAlternance: favori.type == OffreType.alternance,
          popPageWhenFavoriIsRemoved: true,
        ),
      ),
    );
  }

  Widget _buildImmersionItem(BuildContext context, Favori favori) {
    return _buildItem<Immersion>(
      context: context,
      favori: favori,
      selectState: (store) => store.state.immersionFavorisIdsState,
      onTap: () => Navigator.push(
        context,
        ImmersionDetailsPage.materialPageRoute(favori.id, popPageWhenFavoriIsRemoved: true),
      ),
    );
  }

  Widget _buildServiceCiviqueItem(BuildContext context, Favori favori) {
    return _buildItem<ServiceCivique>(
      context: context,
      favori: favori,
      selectState: (store) => store.state.serviceCiviqueFavorisIdsState,
      onTap: () {
        Navigator.push(
          context,
          ServiceCiviqueDetailPage.materialPageRoute(favori.id, true),
        );
      },
    );
  }

  Widget _buildItem<T>({
    required BuildContext context,
    required Favori favori,
    required FavoriIdsState<T> Function(Store<AppState> store) selectState,
    required Function() onTap,
  }) {
    return FavorisStateContext<T>(
      selectState: selectState,
      child: FavoriCard<T>.likable(
        title: favori.titre,
        company: favori.organisation,
        place: favori.localisation,
        offreType: favori.type,
        from: OffrePage.offreFavoris,
        id: favori.id,
        onTap: onTap,
      ),
    );
  }

  List<Favori> _getFavorisFiltered(FavoriListViewModel viewModel) {
    return switch (_selectedFilter) {
      OffreFilter.immersion => viewModel.getOffresImmersion(),
      OffreFilter.serviceCivique => viewModel.getOffresServiceCivique(),
      OffreFilter.emploi => viewModel.getOffresEmploi(),
      OffreFilter.alternance => viewModel.getOffresAlternance(),
      _ => viewModel.favoris
    };
  }

  void _filterSelected(OffreFilter filter) {
    setState(() => _selectedFilter = filter);
    _scrollController.jumpTo(0);
    PassEmploiMatomoTracker.instance.trackScreen(switch (filter) {
      OffreFilter.tous => AnalyticsScreenNames.offreFavorisList,
      OffreFilter.emploi => AnalyticsScreenNames.offreFavorisListFilterEmploi,
      OffreFilter.alternance => AnalyticsScreenNames.offreFavorisListFilterAlternance,
      OffreFilter.immersion => AnalyticsScreenNames.offreFavorisListFilterImmersion,
      OffreFilter.serviceCivique => AnalyticsScreenNames.offreFavorisListFilterServiceCivique
    });
  }
}

class _EmptyListPlaceholder extends StatelessWidget {
  final String title;
  final String subtitle;

  _EmptyListPlaceholder({required this.title, required this.subtitle});

  factory _EmptyListPlaceholder.noFavori() {
    return _EmptyListPlaceholder(
      title: Strings.favorisListEmptyTitle,
      subtitle: Strings.favorisListEmptySubtitle,
    );
  }

  factory _EmptyListPlaceholder.noFavoriFiltered() {
    return _EmptyListPlaceholder(
      title: Strings.favorisFilteredListEmptyTitle,
      subtitle: Strings.favorisFilteredListEmptySubtitle,
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

class _OffreFavorisLoading extends StatelessWidget {
  const _OffreFavorisLoading();

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
