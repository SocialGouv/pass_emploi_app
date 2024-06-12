import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/tracking/tracking_evenement_engagement_action.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/evenement_engagement/evenement_engagement_repository.dart';
import 'package:redux/redux.dart';

class TrackingEvenementEngagementMiddleware extends MiddlewareClass<AppState> {
  final EvenementEngagementRepository _repository;

  TrackingEvenementEngagementMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
    if (action is TrackingEvenementEngagementAction) {
      if (store.state.demoState) return;

      final loginState = store.state.loginState;
      if (loginState is LoginSuccessState) {
        _repository.send(
          userId: loginState.user.id,
          event: action.event,
          loginMode: loginState.user.loginMode,
          brand: store.state.configurationState.getBrand(),
        );
      }
    }
  }
}
