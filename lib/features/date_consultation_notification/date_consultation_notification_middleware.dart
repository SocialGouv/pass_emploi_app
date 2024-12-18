import 'package:pass_emploi_app/features/date_consultation_notification/date_consultation_notification_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/date_consultation_notification_repository.dart';
import 'package:redux/redux.dart';

class DateConsultationNotificationMiddleware extends MiddlewareClass<AppState> {
  final DateConsultationNotificationRepository _repository;

  DateConsultationNotificationMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is DateConsultationNotificationRequestAction) {
      final result = await _repository.get();
      store.dispatch(DateConsultationNotificationSuccessAction(result));
    }

    if (action is DateConsultationNotificationWriteAction) {
      await _repository.save(action.date);
      store.dispatch(DateConsultationNotificationSuccessAction(action.date));
    }
  }
}
