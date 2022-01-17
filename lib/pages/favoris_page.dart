import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_favoris_list_view_model.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_favoris_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/offre_emploi_list_item.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

import 'offre_emploi_details_page.dart';

class FavorisPage extends TraceableStatelessWidget {
  final bool onlyAlternance;

  FavorisPage({required this.onlyAlternance})
      : super(
          name: onlyAlternance ? AnalyticsScreenNames.alternanceFavoris : AnalyticsScreenNames.emploiFavoris,
          key: ValueKey(onlyAlternance),
        );

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OffreEmploiFavorisListViewModel>(
      onInit: (store) => store.dispatch(RequestOffreEmploiFavorisAction()),
      builder: (context, viewModel) => DefaultAnimatedSwitcher(child: _switch(viewModel)),
      converter: (store) => OffreEmploiFavorisListViewModel.create(store, onlyAlternance: onlyAlternance),
      distinct: true,
    );
  }

  Widget _switch(OffreEmploiFavorisListViewModel viewModel) {
    switch (viewModel.displayState) {
      case DisplayState.CONTENT:
        return _listView(viewModel);
      case DisplayState.LOADING:
        return _centeredLike(CircularProgressIndicator(color: AppColors.nightBlue));
      case DisplayState.FAILURE:
        return _centeredLike(Retry(Strings.favorisError, () => viewModel.onRetry()));
      case DisplayState.EMPTY:
        return _centeredLike(Text(Strings.noFavoris, style: TextStyles.textSmRegular()));
    }
  }

  Widget _listView(OffreEmploiFavorisListViewModel viewModel) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (ctx, index) => index == 0 ? _buildFirstItem(ctx, viewModel) : _buildItem(ctx, index, viewModel),
      separatorBuilder: (context, index) => _listSeparator(),
      itemCount: viewModel.items.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }

  Widget _listSeparator() => Container(height: 1, color: AppColors.bluePurpleAlpha20);

  Widget _buildItem(BuildContext context, int index, OffreEmploiFavorisListViewModel viewModel) {
    return Container(
      color: Colors.white,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              OffreEmploiDetailsPage.materialPageRoute(
                viewModel.items[index].id,
                fromAlternance: onlyAlternance,
                shouldPopPageWhenFavoriIsRemoved: true,
              ),
            );
          },
          splashColor: AppColors.bluePurple,
          child: OffreEmploiListItem(
            itemViewModel: viewModel.items[index],
            from: onlyAlternance ? OffrePage.alternanceFavoris : OffrePage.emploiFavoris,
          ),
        ),
      ),
    );
  }

  Widget _buildFirstItem(BuildContext context, OffreEmploiFavorisListViewModel viewModel) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16), bottom: Radius.zero),
      child: _buildItem(context, 0, viewModel),
    );
  }

  // Due to outer FavoritesTabsPage scrollview, making widget matches parent to center it is complicated.
  // Top padding is enough.
  Widget _centeredLike(Widget widget) => Padding(padding: EdgeInsets.only(top: 150), child: Center(child: widget));
}
