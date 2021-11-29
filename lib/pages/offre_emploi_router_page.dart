import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/offre_emploi_list_page.dart';
import 'package:pass_emploi_app/pages/solutions_tabs_page.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_router_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';

class OffreEmploiRouterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OffreEmploiRouterViewModel>(
      converter: (store) => OffreEmploiRouterViewModel.create(store),
      builder: (context, vm) => _content(vm.displayState),
      onWillChange: (_, newViewModel) => {
        if (newViewModel.displayState == OffreEmploiRouterDisplayState.SHOW_LIST)
          Navigator.push(context, MaterialPageRoute(builder: (context) => OffreEmploiListPage()))
        else if (newViewModel.displayState == OffreEmploiRouterDisplayState.SHOW_SEARCH)
          Navigator.pop(context)
      },
      distinct: true,
    );
  }

  Widget _content(OffreEmploiRouterDisplayState displayState) {
    return SolutionsTabPage();
  }
}
