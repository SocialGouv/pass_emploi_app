import 'package:pass_emploi_app/models/commentaire.dart';

abstract class ActionCommentaireListState {}

class ActionCommentaireListNotInitializedState extends ActionCommentaireListState {}

class ActionCommentaireListLoadingState extends ActionCommentaireListState {}

class ActionCommentaireListSuccessState extends ActionCommentaireListState {
  final List<Commentaire> comments;

  ActionCommentaireListSuccessState(this.comments);
}

class ActionCommentaireListFailureState extends ActionCommentaireListState {}