import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/log.dart';
import 'package:redux/redux.dart';

class ActionLoggingMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    Log.d("ACTIONS - ${_stripActionName(action)}");
    next(action);
  }

  String _stripActionName(dynamic action) {
    return action.toString().replaceAll("'", "").replaceFirst("Instance of ", "");
  }
}
