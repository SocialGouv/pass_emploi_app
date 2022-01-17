import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_favoris_list_view_model.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_favoris_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/data_card.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      itemBuilder: (context, index) => _buildItem(context, index, viewModel),
      separatorBuilder: (context, index) => _listSeparator(),
      itemCount: viewModel.items.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }

  Widget _listSeparator() => Container(height: 16);

  Widget _buildItem(BuildContext context, int index, OffreEmploiFavorisListViewModel viewModel) {
    var item = viewModel.items[index];
    return DataCard(
      titre: item.title,
      sousTitre: item.companyName,
      lieu: item.location,
      dataTag: [item.contractType, item.duration].whereType<String>().toList(),
      id: item.id,
      onTap: () => Navigator.push(
          context,
          OffreEmploiDetailsPage.materialPageRoute(item.id,
              fromAlternance: onlyAlternance,shouldPopPageWhenFavoriIsRemoved: true, fromAlternance: onlyAlternance)),
    );
  }

  // Due to outer FavoritesTabsPage scrollview, making widget matches parent to center it is complicated.
  // Top padding is enough.
  Widget _centeredLike(Widget widget) => Padding(padding: EdgeInsets.only(top: 150), child: Center(child: widget));
}
