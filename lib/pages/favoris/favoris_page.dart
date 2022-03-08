import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_actions.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/favori_list_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:redux/redux.dart';

abstract class AbstractFavorisPage<FAVORIS_MODEL, FAVORIS_VIEW_MODEL> extends TraceableStatelessWidget {
  final String analyticsScreenName;
  final FavoriListState<FAVORIS_MODEL> Function(Store<AppState> store) selectState;

  const AbstractFavorisPage({
    required this.analyticsScreenName,
    required this.selectState,
    Key? key,
  }) : super(name: analyticsScreenName, key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, FavorisListViewModel<FAVORIS_MODEL, FAVORIS_VIEW_MODEL>>(
      onInit: (store) => store.dispatch(FavoriListRequestAction<FAVORIS_MODEL>()),
      builder: (context, viewModel) => FavorisStateContext<FAVORIS_MODEL>(
        selectState: selectState,
        child: DefaultAnimatedSwitcher(child: _switch(context, viewModel)),
      ),
      converter: converter,
      distinct: true,
    );
  }

  Widget _switch(BuildContext context, FavorisListViewModel<FAVORIS_MODEL, FAVORIS_VIEW_MODEL> viewModel) {
    switch (viewModel.displayState) {
      case DisplayState.CONTENT:
        return _listView(context, viewModel);
      case DisplayState.LOADING:
        return _centeredLike(CircularProgressIndicator(color: AppColors.nightBlue));
      case DisplayState.FAILURE:
        return _centeredLike(Retry(Strings.favorisError, () => viewModel.onRetry()));
      case DisplayState.EMPTY:
        return _centeredLike(Text(Strings.noFavoris, style: TextStyles.textSmRegular()));
    }
  }

  Widget _listView(BuildContext context, FavorisListViewModel<FAVORIS_MODEL, FAVORIS_VIEW_MODEL> viewModel) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      itemBuilder: (context, index) => item(context, viewModel.items[index]),
      separatorBuilder: (context, index) => _listSeparator(),
      itemCount: viewModel.items.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }

  Widget _listSeparator() => Container(height: Margins.spacing_base);

  // Due to outer FavoritesTabsPage scrollview, making widget matches parent to center it is complicated.
  // Top padding is enough.
  Widget _centeredLike(Widget widget) => Padding(padding: EdgeInsets.only(top: 150), child: Center(child: widget));

  FavorisListViewModel<FAVORIS_MODEL, FAVORIS_VIEW_MODEL> converter(Store<AppState> store);

  Widget item(BuildContext context, FAVORIS_VIEW_MODEL itemViewModel);
}
