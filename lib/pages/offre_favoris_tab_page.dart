import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/features/favori/list_v2/favori_list_v2_actions.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/models/solution_type.dart';
import 'package:pass_emploi_app/pages/immersion_details_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi_details_page.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/pages/service_civique/service_civique_detail_page.dart';
import 'package:pass_emploi_app/presentation/favori_list_v2_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/favori_card.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:redux/redux.dart';

class OffreFavorisTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.offreFavoris,
      child: StoreConnector<AppState, FavoriListV2ViewModel>(
        onInit: (store) => store.dispatch(FavoriListV2RequestAction()),
        converter: (store) => FavoriListV2ViewModel.create(store),
        builder: _builder,
        distinct: true,
      ),
    );
  }

  Widget _builder(BuildContext context, FavoriListV2ViewModel viewModel) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Center(child: _content(viewModel)),
    );
  }

  Widget _content(FavoriListV2ViewModel viewModel) {
    if (viewModel.displayState.isLoading()) return CircularProgressIndicator();
    if (viewModel.displayState.isFailure()) return Retry(Strings.favorisError, () => viewModel.onRetry());
    if (viewModel.displayState.isEmpty()) return Text(Strings.noFavoris, style: TextStyles.textSRegular());
    return _favoris(viewModel.favoris);
  }

  Widget _favoris(List<Favori> favoris) {
    return ListView.separated(
      padding: const EdgeInsets.all(Margins.spacing_base),
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
    );
  }

  Widget _buildOffreEmploiItem(BuildContext context, Favori favori) {
    return _buildItem<OffreEmploi>(
      context: context,
      favori: favori,
      selectState: (store) => store.state.offreEmploiFavorisState,
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
      selectState: (store) => store.state.immersionFavorisState,
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
      selectState: (store) => store.state.serviceCiviqueFavorisState,
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
    required FavoriListState<T> Function(Store<AppState> store) selectState,
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
}
