import 'package:pass_emploi_app/features/user_action/commentaire/create/action_commentaire_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_actions.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_state.dart';
import 'package:pass_emploi_app/models/commentaire.dart';

ActionCommentaireListState actionCommentaireListReducer(ActionCommentaireListState current, dynamic action) {
  if (action is ActionCommentaireListLoadingAction) return ActionCommentaireListLoadingState();
  if (action is ActionCommentaireListFailureAction) return ActionCommentaireListFailureState();
  if (action is ActionCommentaireListSuccessAction) return ActionCommentaireListSuccessState(action.comments);
  if (action is ActionCommentaireCreateSuccessAction) return _updatedList(current, action);
  return current;
}

ActionCommentaireListState _updatedList(
  ActionCommentaireListState current,
  ActionCommentaireCreateSuccessAction action,
) {
  if (current is! ActionCommentaireListSuccessState) return current;
  final List<Commentaire> currentComments = current.comments;
  currentComments.add(
    Commentaire(
      id: action.actionId,
      content: action.comment,
      creationDate: DateTime.now(),
      creatorName: null,
      createdByAdvisor: false,
    ),
  );
  return ActionCommentaireListSuccessState(currentComments);
}
