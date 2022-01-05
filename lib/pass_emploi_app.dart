import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/router_page.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/theme.dart';
import 'package:redux/redux.dart';

class PassEmploiApp extends StatelessWidget {
  final Store<AppState> _store;

  PassEmploiApp(this._store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: _store,
      child: MaterialApp(
        title: Strings.appName,
        theme: PassEmploiTheme.data,
        home: RouterPage(),
      ),
    );
  }
}
