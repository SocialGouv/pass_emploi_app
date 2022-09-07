import 'package:pass_emploi_app/models/commentaire.dart';

class ActionCommentaireListRequestAction {
  final String actionId;

  ActionCommentaireListRequestAction(this.actionId);
}

class ActionCommentaireListLoadingAction {}

class ActionCommentaireListSuccessAction {
  final List<Commentaire> comments;

  ActionCommentaireListSuccessAction(this.comments);
}

class ActionCommentaireListFailureAction {}