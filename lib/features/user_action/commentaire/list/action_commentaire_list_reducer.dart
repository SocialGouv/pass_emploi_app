import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_actions.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_state.dart';

ActionCommentaireListState actionCommentaireListReducer(ActionCommentaireListState current, dynamic action) {
  if (action is ActionCommentaireListLoadingAction) return ActionCommentaireListLoadingState();
  if (action is ActionCommentaireListFailureAction) return ActionCommentaireListFailureState();
  if (action is ActionCommentaireListSuccessAction) return ActionCommentaireListSuccessState(action.comments);
  return current;
}
