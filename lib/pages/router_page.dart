import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/home_page.dart';
import 'package:pass_emploi_app/presentation/login_page.dart';
import 'package:pass_emploi_app/presentation/router_view_model.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';

class RouterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var storeConnector = StoreConnector<AppState, RouterViewModel>(
      converter: (store) => RouterViewModel.create(store),
      builder: (context, viewModel) => viewModel.withLoginPage ? LoginPage() : HomePage(),
    );
    StoreProvider.of<AppState>(context).dispatch(BootstrapAction());
    return storeConnector;
  }
}
