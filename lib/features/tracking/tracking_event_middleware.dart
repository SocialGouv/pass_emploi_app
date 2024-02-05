import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/tracking/tracking_event_action.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/tracking_analytics/tracking_event_repository.dart';
import 'package:redux/redux.dart';

class TrackingEventMiddleware extends MiddlewareClass<AppState> {
  final TrackingEventRepository _repository;

  TrackingEventMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
    if (action is TrackingEventAction) {
      if (store.state.demoState) return;

      final loginState = store.state.loginState;
      if (loginState is LoginSuccessState) {
        _repository.sendEvent(
          userId: loginState.user.id,
          event: action.event,
          loginMode: loginState.user.loginMode,
          brand: store.state.configurationState.getBrand(),
        );
      }
    }
  }
}
