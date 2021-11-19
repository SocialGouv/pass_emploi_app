import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/offre_emploi_list_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi_search_page.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_router_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';

class OffreEmploiRouterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OffreEmploiRouterViewModel>(
      converter: (store) => OffreEmploiRouterViewModel.create(store),
      builder: (context, vm) => _content(vm.displayState),
      distinct: true,
    );
  }

  Widget _content(OffreEmploiRouterDisplayState displayState) {
    switch (displayState) {
      case OffreEmploiRouterDisplayState.SHOW_SEARCH:
        return OffreEmploiSearchPage();
      case OffreEmploiRouterDisplayState.SHOW_LIST:
        return OffreEmploiListPage();
    }
  }
}
