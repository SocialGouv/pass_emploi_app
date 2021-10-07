import 'dart:developer';

import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

class ActionLoggingMiddleware extends MiddlewareClass<AppState> {
  @override
  call(Store<AppState> store, action, NextDispatcher next) {
    log("${_stripActionName(action)}", name: "ACTIONS");
    next(action);
  }

  String _stripActionName(dynamic action) {
    return action.toString().replaceAll("'", "").replaceFirst("Instance of ", "");
  }
}
