import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_state.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_actions.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/models/solution_type.dart';
import 'package:pass_emploi_app/pages/immersion_details_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi_details_page.dart';
import 'package:pass_emploi_app/pages/offre_filters_page.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/pages/service_civique/service_civique_detail_page.dart';
import 'package:pass_emploi_app/presentation/favori_list_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/filtre_button.dart';
import 'package:pass_emploi_app/widgets/cards/favori_card.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';
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

  Widget _content(FavoriListViewModel viewModel) {
    if (viewModel.displayState.isLoading()) return CircularProgressIndicator();
    if (viewModel.displayState.isFailure()) return Retry(Strings.favorisError, () => viewModel.onRetry());
    if (viewModel.displayState.isEmpty()) return _Empty();
    return _favoris(viewModel);
  }

  Widget _favoris(FavoriListViewModel viewModel) {
    final favoris = _getFavorisFiltered(viewModel);
    if (favoris.isEmpty) return _Empty();
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
          case SolutionType.OffreEmploi:
          case SolutionType.Alternance:
            return _buildOffreEmploiItem(context, favori);
          case SolutionType.Immersion:
            return _buildImmersionItem(context, favori);
          case SolutionType.ServiceCivique:
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
          fromAlternance: favori.type == SolutionType.Alternance,
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
        bottomTip: Strings.voirLeDetail,
        solutionType: favori.type,
        from: OffrePage.offreFavoris,
        id: favori.id,
        onTap: onTap,
      ),
    );
  }

  List<Favori> _getFavorisFiltered(FavoriListViewModel viewModel) {
    switch (_selectedFilter) {
      case OffreFilter.immersion:
        return viewModel.getOffresImmersion();
      case OffreFilter.serviceCivique:
        return viewModel.getOffresServiceCivique();
      case OffreFilter.emploi:
        return viewModel.getOffresEmploi();
      case OffreFilter.alternance:
        return viewModel.getOffresAlternance();
      default:
        return viewModel.favoris;
    }
  }

  void _filterSelected(OffreFilter filter) {
    setState(() => _selectedFilter = filter);
    _scrollController.jumpTo(0);
    final String tracking;
    switch (filter) {
      case OffreFilter.tous:
        tracking = AnalyticsScreenNames.offreFavorisList;
        break;
      case OffreFilter.emploi:
        tracking = AnalyticsScreenNames.offreFavorisListFilterEmploi;
        break;
      case OffreFilter.alternance:
        tracking = AnalyticsScreenNames.offreFavorisListFilterAlternance;
        break;
      case OffreFilter.immersion:
        tracking = AnalyticsScreenNames.offreFavorisListFilterImmersion;
        break;
      case OffreFilter.serviceCivique:
        tracking = AnalyticsScreenNames.offreFavorisListFilterServiceCivique;
        break;
    }
    PassEmploiMatomoTracker.instance.trackScreen(tracking);
  }
}

class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Text(Strings.noFavoris, style: TextStyles.textSRegular());
}
