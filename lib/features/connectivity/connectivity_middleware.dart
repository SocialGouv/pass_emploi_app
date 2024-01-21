import 'package:pass_emploi_app/features/connectivity/connectivity_actions.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/wrappers/connectivity_wrapper.dart';
import 'package:redux/redux.dart';

class ConnectivityMiddleware extends MiddlewareClass<AppState> {
  final ConnectivityWrapper _connectivityWrapper;
  final ModeDemoRepository _demoRepository;

  ConnectivityMiddleware(this._connectivityWrapper, this._demoRepository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (_demoRepository.isModeDemo()) return;
    if (action is SubscribeToConnectivityUpdatesAction) {
      _connectivityWrapper.subscribeToUpdates((result) => store.dispatch(ConnectivityUpdatedAction(result)));
    }
    if (action is UnsubscribeFromConnectivityUpdatesAction) {
      _connectivityWrapper.unsubscribeFromUpdates();
    }
  }
}
