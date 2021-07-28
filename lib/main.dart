import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pass_emploi_app.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

void main() {
  final store = Store<AppState>(
    reducer,
    initialState: AppState.initialState(),
  );

  runApp(PassEmploiApp(store));
}
