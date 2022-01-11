import 'package:pass_emploi_app/redux/actions/tracking_event_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/tracking_analytics/tracking_event_repository.dart';
import 'package:redux/redux.dart';

class TrackingEventMiddleware extends MiddlewareClass<AppState> {
  final TrackingEventRepository _repository;

  TrackingEventMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
    if (action is RequestTrackingEventAction) {
      final loginState = store.state.loginState;
      if (loginState.isSuccess()) {
        final userId = loginState.getResultOrThrow().id;
        final loginMode = loginState.getResultOrThrow().loginMode;
        _repository.sendEvent(userId: userId, event: action.event, loginMode: loginMode);
      }
    }
  }
}
