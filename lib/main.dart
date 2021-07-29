import 'dart:io';

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
  final baseUrl = _baseUrl();
  final store = _initializeReduxStore(baseUrl);
  runApp(PassEmploiApp(store));
}

_baseUrl() {
  // Must be declared as const https://github.com/flutter/flutter/issues/55870
  const env = String.fromEnvironment('NGROK_SERVER_ID');
  if (env.isEmpty && Platform.environment['FLUTTER_TEST'] == "false") {
    throw ("A Ngrok server ID must be set in build arguments --dart-define=NGROK_SERVER_ID=<YOUR_SERVER_ID>."
        "For more details, please refer to the project README.md.");
  }
  final baseUrl = "https://$env.ngrok.io";
  print("SERVER BASE URL = $baseUrl");
  return baseUrl;
}

Store<AppState> _initializeReduxStore(String baseUrl) {
  return Store<AppState>(
    reducer,
    initialState: AppState.initialState(),
    middleware: [LoginMiddleware(UserRepository()), ApiMiddleware(HomeRepository(baseUrl))],
  );
}
