import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_favoris_list_view_model.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_favoris_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';

class FavorisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OffreEmploiFavorisListViewModel>(
      onInit: (store) => store.dispatch(RequestOffreEmploiFavorisAction()),
      builder: (context, vm) => Container(),
      converter: (store) => OffreEmploiFavorisListViewModel.create(store),
    );
  }
}
