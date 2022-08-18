class ActionCommentaireCreateRequestAction {
  final String actionId;
  final String comment;

  ActionCommentaireCreateRequestAction({required this.actionId, required this.comment});
}

class ActionCommentaireCreateLoadingAction {}

class ActionCommentaireCreateSuccessAction {}

class ActionCommentaireCreateFailureAction {
  final String comment;

  ActionCommentaireCreateFailureAction(this.comment);
}

class ActionCommentaireCreateResetAction {}
