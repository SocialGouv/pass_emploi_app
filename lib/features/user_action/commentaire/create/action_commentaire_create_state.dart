import 'package:equatable/equatable.dart';

abstract class ActionCommentaireCreateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ActionCommentaireCreateNotInitializedState extends ActionCommentaireCreateState {}

class ActionCommentaireCreateLoadingState extends ActionCommentaireCreateState {}

class ActionCommentaireCreateSuccessState extends ActionCommentaireCreateState {}

class ActionCommentaireCreateFailureState extends ActionCommentaireCreateState {
  final String comment;

  ActionCommentaireCreateFailureState(this.comment);

  @override
  List<Object?> get props => [comment];
}