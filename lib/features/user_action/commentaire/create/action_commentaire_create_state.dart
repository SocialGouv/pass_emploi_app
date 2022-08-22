abstract class ActionCommentaireCreateState {}

class ActionCommentaireCreateNotInitializedState extends ActionCommentaireCreateState {}

class ActionCommentaireCreateLoadingState extends ActionCommentaireCreateState {}

class ActionCommentaireCreateSuccessState extends ActionCommentaireCreateState {}

class ActionCommentaireCreateFailureState extends ActionCommentaireCreateState {
  final String comment;

  ActionCommentaireCreateFailureState(this.comment);
}