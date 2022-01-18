import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/favoris_list_view_model.dart';
import 'package:pass_emploi_app/redux/actions/favoris_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/data_card.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:redux/redux.dart';

abstract class AbstractFavorisPage<FAVORIS_MODEL, FAVORIS_VIEW_MODEL> extends TraceableStatelessWidget {
  final String analyticsScreenName;

  const AbstractFavorisPage({required this.analyticsScreenName, Key? key}) : super(name: analyticsScreenName, key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, FavorisListViewModel<FAVORIS_MODEL, FAVORIS_VIEW_MODEL>>(
      onInit: (store) => store.dispatch(RequestFavorisAction<FAVORIS_MODEL>()),
      builder: (context, viewModel) => DefaultAnimatedSwitcher(child: _switch(viewModel)),
      converter: converter,
      distinct: true,
    );
  }

  Widget _switch(FavorisListViewModel<FAVORIS_MODEL, FAVORIS_VIEW_MODEL> viewModel) {
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

  Widget _listView(FavorisListViewModel<FAVORIS_MODEL, FAVORIS_VIEW_MODEL> viewModel) {
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
        OffreEmploiDetailsPage.materialPageRoute(
          item.id,
          fromAlternance: onlyAlternance,
          shouldPopPageWhenFavoriIsRemoved: true,
        ),
      ),
    );
  }

  // Due to outer FavoritesTabsPage scrollview, making widget matches parent to center it is complicated.
  // Top padding is enough.
  Widget _centeredLike(Widget widget) => Padding(padding: EdgeInsets.only(top: 150), child: Center(child: widget));

  FavorisListViewModel<FAVORIS_MODEL, FAVORIS_VIEW_MODEL> converter(Store<AppState> store);

  MaterialPageRoute detailsPageRoute(FAVORIS_VIEW_MODEL itemViewModel);

  Widget item(FAVORIS_VIEW_MODEL itemViewModel);
}