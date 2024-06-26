import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/action_commentaire_repository.dart';
import 'package:redux/redux.dart';

class ActionCommentaireListMiddleware extends MiddlewareClass<AppState> {
  final ActionCommentaireRepository _repository;

  ActionCommentaireListMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is ActionCommentaireListRequestAction) {
      store.dispatch(ActionCommentaireListLoadingAction());
      final comments = await _repository.getCommentaires(action.actionId);
      store.dispatch(
        comments != null ? ActionCommentaireListSuccessAction(comments) : ActionCommentaireListFailureAction(),
      );
    }
  }
}
