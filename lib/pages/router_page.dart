import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/home_page.dart';
import 'package:pass_emploi_app/pages/login_page.dart';
import 'package:pass_emploi_app/pages/spash_screen_page.dart';
import 'package:pass_emploi_app/presentation/router_view_model.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';

class RouterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RouterViewModel>(
      onInit: (store) => store.dispatch(BootstrapAction()),
      converter: (store) => RouterViewModel.create(store),
      onDidChange: (previousVm, newVm) => _handleNavigation(context, newVm),
      builder: (context, viewModel) => Scaffold(),
      distinct: true,
    );
  }

  _handleNavigation(BuildContext context, RouterViewModel viewModel) {
    if (viewModel.withSplashScreen) {
      Navigator.push(context, SplashScreenPage.materialPageRoute());
    } else if (viewModel.withLoginPage) {
      Navigator.pushReplacement(context, LoginPage.materialPageRoute());
    } else {
      Navigator.pushReplacement(context, HomePage.materialPageRoute());
    }
  }
}
