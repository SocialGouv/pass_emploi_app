class ActionCommentaireCreateRequestAction {
  final String actionId;
  final String comment;

  ActionCommentaireCreateRequestAction({required this.actionId, required this.comment});
}

class ActionCommentaireCreateLoadingAction {}

class ActionCommentaireCreateSuccessAction {
  final String actionId;
  final String comment;

  ActionCommentaireCreateSuccessAction({required this.actionId, required this.comment});
}

class ActionCommentaireCreateFailureAction {
  final String comment;

  ActionCommentaireCreateFailureAction(this.comment);
}

class ActionCommentaireCreateResetAction {}
