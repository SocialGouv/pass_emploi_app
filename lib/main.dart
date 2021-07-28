import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pass_emploi_app.dart';
import 'package:pass_emploi_app/redux/middlewares/api_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/login_middleware.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/home_repository.dart';
import 'package:pass_emploi_app/repositories/user_repository.dart';
import 'package:redux/redux.dart';

void main() {
  final store = _initializeReduxStore();
  runApp(PassEmploiApp(store));
}

Store<AppState> _initializeReduxStore() {
  return Store<AppState>(
    reducer,
    initialState: AppState.initialState(),
    middleware: [
      LoginMiddleware(UserRepository()),
      ApiMiddleware(HomeRepository("https://NGROK_ID.ngrok.io")) // TODO use environment variable
    ],
  );
}
