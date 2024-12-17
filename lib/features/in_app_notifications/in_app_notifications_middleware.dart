import 'package:pass_emploi_app/features/in_app_notifications/in_app_notifications_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/in_app_notifications_repository.dart';
import 'package:redux/redux.dart';

class InAppNotificationsMiddleware extends MiddlewareClass<AppState> {
  final InAppNotificationsRepository _repository;

  InAppNotificationsMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId == null) return;
    if (action is InAppNotificationsRequestAction) {
      store.dispatch(InAppNotificationsLoadingAction());
      final result = await _repository.get(userId);
      if (result != null) {
        store.dispatch(InAppNotificationsSuccessAction(result));
      } else {
        store.dispatch(InAppNotificationsFailureAction());
      }
    }
  }
}
