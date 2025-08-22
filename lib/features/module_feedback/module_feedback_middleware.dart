import 'package:pass_emploi_app/features/module_feedback/module_feedback_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/module_feedback_repository.dart';
import 'package:redux/redux.dart';

class ModuleFeedbackMiddleware extends MiddlewareClass<AppState> {
  final ModuleFeedbackRepository _repository;

  ModuleFeedbackMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is ModuleFeedbackRequestAction) {
      await _repository.post(
        tag: action.tag,
        note: action.note,
        commentaire: action.commentaire,
      );
    }
  }
}
