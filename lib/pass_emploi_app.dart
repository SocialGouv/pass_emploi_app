import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/actions_page.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

class PassEmploiApp extends StatelessWidget {
  final Store<AppState> _store;

  PassEmploiApp(this._store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: _store,
      child: MaterialApp(
        title: 'Pass Emploi',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: ActionsPage(),
      ),
    );
  }
}
