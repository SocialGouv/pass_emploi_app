import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/pages/app_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_favoris_list_view_model.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_favoris_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/offre_emploi_list_item.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

import 'offre_emploi_details_page.dart';

class FavorisPage extends TraceableStatelessWidget {
  final bool onlyAlternance;

  FavorisPage({required this.onlyAlternance}) : super(name: AnalyticsScreenNames.emploiFavoris);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OffreEmploiFavorisListViewModel>(
      onInit: (store) => store.dispatch(RequestOffreEmploiFavorisAction()),
      builder: (context, viewModel) => _scaffold(context, viewModel),
      converter: (store) => OffreEmploiFavorisListViewModel.create(store, onlyAlternance: onlyAlternance),
      distinct: true,
    );
  }

  Widget _scaffold(BuildContext context, OffreEmploiFavorisListViewModel viewModel) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: FlatDefaultAppBar(
        title: Text(Strings.menuFavoris, style: TextStyles.h3Semi),
      ),
      body: DefaultAnimatedSwitcher(child: _switch(viewModel)),
    );
  }

  Widget _switch(OffreEmploiFavorisListViewModel viewModel) {
    switch (viewModel.displayState) {
      case DisplayState.CONTENT:
        return _listView(viewModel);
      case DisplayState.LOADING:
        return _loading();
      case DisplayState.FAILURE:
        return Center(child: Retry(Strings.favorisError, () => viewModel.onRetry()));
      case DisplayState.EMPTY:
        return _empty();
    }
  }

  ListView _listView(OffreEmploiFavorisListViewModel viewModel) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      itemBuilder: (context, index) =>
          index == 0 ? _buildFirstItem(context, viewModel) : _buildItem(context, index, viewModel),
      separatorBuilder: (context, index) => _listSeparator(),
      itemCount: viewModel.items.length,
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
                  shouldPopPageWhenFavoriIsRemoved: true,
                ));
          },
          splashColor: AppColors.bluePurple,
          child: OffreEmploiListItem(itemViewModel: viewModel.items[index], from: AppPage.emploiFavoris),
        ),
      ),
    );
  }

  Widget _buildFirstItem(
    BuildContext context,
    OffreEmploiFavorisListViewModel viewModel,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16), bottom: Radius.zero),
      child: _buildItem(context, 0, viewModel),
    );
  }

  Widget _loading() => Center(child: CircularProgressIndicator(color: AppColors.nightBlue));

  Widget _empty() {
    return Center(child: Text(Strings.noFavoris, style: TextStyles.textSmRegular()));
  }
}
