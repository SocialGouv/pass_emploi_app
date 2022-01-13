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
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

import 'offre_emploi_details_page.dart';

class FavorisPage extends TraceableStatelessWidget {
  FavorisPage() : super(name: AnalyticsScreenNames.favoris);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OffreEmploiFavorisListViewModel>(
      onInit: (store) => store.dispatch(RequestOffreEmploiFavorisAction()),
      builder: (context, viewModel) => _scaffold(context, viewModel),
      converter: (store) => OffreEmploiFavorisListViewModel.create(store),
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
      itemBuilder: (context, index) => _buildItem(context, index, viewModel),
      separatorBuilder: (context, index) => _listSeparator(),
      itemCount: viewModel.items.length,
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
            shouldPopPageWhenFavoriIsRemoved: true,
          )),
    );
  }

  Widget _loading() => Center(child: CircularProgressIndicator(color: AppColors.nightBlue));

  Widget _empty() {
    return Center(child: Text(Strings.noFavoris, style: TextStyles.textSmRegular()));
  }
}
