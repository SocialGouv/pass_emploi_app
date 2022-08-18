import 'package:pass_emploi_app/features/user_action/commentaire/create/action_commentaire_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/create/action_commentaire_create_state.dart';

ActionCommentaireCreateState actionCommentaireCreateReducer(ActionCommentaireCreateState current, dynamic action) {
  if (action is ActionCommentaireCreateLoadingAction) return ActionCommentaireCreateLoadingState();
  if (action is ActionCommentaireCreateFailureAction) return ActionCommentaireCreateFailureState(action.comment);
  if (action is ActionCommentaireCreateSuccessAction) return ActionCommentaireCreateSuccessState();
  return current;
}
