import 'package:pass_emploi_app/features/connectivity/connectivity_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/wrappers/connectivity_wrapper.dart';
import 'package:redux/redux.dart';

class ConnectivityMiddleware extends MiddlewareClass<AppState> {
  final ConnectivityWrapper _connectivityWrapper;

  ConnectivityMiddleware(this._connectivityWrapper);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is SubscribeToConnectivityUpdatesAction) {
      _connectivityWrapper.subscribeToUpdates((result) => store.dispatch(ConnectivityUpdatedAction(result)));
    }
    if (action is UnsubscribeFromConnectivityUpdatesAction) {
      _connectivityWrapper.unsubscribeFromUpdates();
    }
  }
}
