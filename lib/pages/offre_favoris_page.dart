import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_state.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_actions.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/pages/immersion/immersion_details_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi/offre_emploi_details_page.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/pages/service_civique/service_civique_detail_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/favori_list_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/animated_list_loader.dart';
import 'package:pass_emploi_app/widgets/cards/favori_card.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';
import 'package:pass_emploi_app/widgets/illustration/empty_state_placeholder.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:redux/redux.dart';

class OffreFavorisPage extends StatelessWidget {
  final _scrollController = ScrollController();
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => OffreFavorisPage());
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.offreFavorisList,
      child: StoreConnector<AppState, FavoriListViewModel>(
        onInit: (store) => store.dispatch(FavoriListRequestAction()),
        converter: (store) => FavoriListViewModel.create(store),
        builder: _builder,
        distinct: true,
      ),
    );
  }

  Widget _builder(BuildContext context, FavoriListViewModel viewModel) {
    return Center(
      child: AnimatedSwitcher(
        duration: AnimationDurations.fast,
        child: switch (viewModel.displayState) {
          DisplayState.LOADING => _OffreFavorisLoading(),
          DisplayState.FAILURE => Retry(Strings.favorisError, () => viewModel.onRetry()),
          DisplayState.EMPTY => _EmptyListPlaceholder.noFavori(),
          DisplayState.CONTENT => _favoris(viewModel),
        },
      ),
    );
  }

  Widget _favoris(FavoriListViewModel viewModel) {
    if (viewModel.favoris.isEmpty) return _EmptyListPlaceholder.noFavoriFiltered();
    return ListView.separated(
      padding: const EdgeInsets.all(Margins.spacing_base),
      itemCount: viewModel.favoris.length,
      itemBuilder: (context, index) {
        final favori = viewModel.favoris[index];
        return switch (favori.type) {
          OffreType.emploi || OffreType.alternance => _buildOffreEmploiItem(context, favori),
          OffreType.immersion => _buildImmersionItem(context, favori),
          OffreType.serviceCivique => _buildServiceCiviqueItem(context, favori)
        };
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
