import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_actions.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_state.dart';
import 'package:pass_emploi_app/models/commentaire.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ActionCommentaireViewModel extends Equatable {
  final List<Commentaire> comments;
  final Commentaire? lastComment;
  final DisplayState displayState;
  final Function() onRetry;

  ActionCommentaireViewModel._({
    required this.comments,
    required this.lastComment,
    required this.displayState,
    required this.onRetry,
  });

  factory ActionCommentaireViewModel.create(Store<AppState> store, String userActionId) {
    final commentState = store.state.actionCommentaireListState;
    final List<Commentaire> commentsList = commentState is ActionCommentaireListSuccessState
        ? (store.state.actionCommentaireListState as ActionCommentaireListSuccessState).comments
        : [];
    return ActionCommentaireViewModel._(
      comments: commentsList,
      lastComment: commentsList.isNotEmpty ? commentsList.last : null,
      displayState: _commentDisplayState(commentState),
      onRetry: () => store.dispatch(ActionCommentaireListRequestAction(userActionId)),
    );
  }

  @override
  List<Object?> get props => [displayState, comments, lastComment];
}


DisplayState _commentDisplayState(ActionCommentaireListState state) {
  if (state is ActionCommentaireListFailureState) return DisplayState.erreur;
  if (state is ActionCommentaireListSuccessState) return DisplayState.contenu;
  return DisplayState.chargement;
}