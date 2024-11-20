import 'package:pass_emploi_app/features/in_app_feedback/in_app_feedback_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/in_app_feedback_repository.dart';
import 'package:redux/redux.dart';

class InAppFeedbackMiddleware extends MiddlewareClass<AppState> {
  final InAppFeedbackRepository _repository;

  InAppFeedbackMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is InAppFeedbackRequestAction) {
      final activation = await _repository.isFeedbackActivated(action.feature);
      store.dispatch(InAppFeedbackSuccessAction(MapEntry(action.feature, activation)));
    }

    if (action is InAppFeedbackDismissAction) {
      await _repository.dismissFeedback(action.feature);
      store.dispatch(InAppFeedbackSuccessAction(MapEntry(action.feature, false)));
    }
  }
}
