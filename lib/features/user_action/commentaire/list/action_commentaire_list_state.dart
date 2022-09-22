import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/commentaire.dart';

abstract class ActionCommentaireListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ActionCommentaireListNotInitializedState extends ActionCommentaireListState {}

class ActionCommentaireListLoadingState extends ActionCommentaireListState {}

class ActionCommentaireListSuccessState extends ActionCommentaireListState {
  final List<Commentaire> comments;

  ActionCommentaireListSuccessState(this.comments);

  @override
  List<Object?> get props => [comments];
}

class ActionCommentaireListFailureState extends ActionCommentaireListState {}
