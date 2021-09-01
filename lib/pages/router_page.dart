import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/home_page.dart';
import 'package:pass_emploi_app/pages/spash_screen_page.dart';
import 'package:pass_emploi_app/presentation/login_page.dart';
import 'package:pass_emploi_app/presentation/router_view_model.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';

class RouterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final storeConnector = StoreConnector<AppState, RouterViewModel>(
      converter: (store) => RouterViewModel.create(store),
      builder: (context, viewModel) => _body(viewModel),
    );
    StoreProvider.of<AppState>(context).dispatch(BootstrapAction());
    return storeConnector;
  }

  Widget _body(RouterViewModel viewModel) {
    if (viewModel.withSplashScreen) return SplashScreenPage();
    if (viewModel.withLoginPage) return LoginPage();
    return HomePage();
  }
}
