import 'package:pass_emploi_app/features/user_action/commentaire/create/action_commentaire_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/action_commentaire_repository.dart';
import 'package:redux/redux.dart';

class ActionCommentaireCreateMiddleware extends MiddlewareClass<AppState> {
  final ActionCommentaireRepository _repository;

  ActionCommentaireCreateMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is ActionCommentaireCreateRequestAction) {
      store.dispatch(ActionCommentaireCreateLoadingAction());
      final isSent = await _repository.sendCommentaire(actionId: action.actionId, comment: action.comment);
      if (isSent) {
        store.dispatch(ActionCommentaireCreateSuccessAction());
        store.dispatch(ActionCommentaireListRequestAction(action.actionId));
      } else {
        store.dispatch(ActionCommentaireCreateFailureAction());
      }
    }
  }
}
