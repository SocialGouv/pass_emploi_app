import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/create/action_commentaire_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/create/action_commentaire_create_state.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_actions.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_state.dart';
import 'package:pass_emploi_app/models/commentaire.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ActionCommentairePageViewModel extends Equatable {
  final List<Commentaire> comments;
  final DisplayState listDisplayState;
  final DisplayState sendDisplayState;
  final Function() onRetry;
  final Function(String) onSend;
  final bool errorOnSend;
  final String? draft;

  ActionCommentairePageViewModel._({
    required this.comments,
    required this.listDisplayState,
    required this.sendDisplayState,
    required this.onRetry,
    required this.onSend,
    required this.errorOnSend,
    required this.draft,
  });

  factory ActionCommentairePageViewModel.create(Store<AppState> store, String userActionId) {
    final commentListState = store.state.actionCommentaireListState;
    final List<Commentaire> commentsList = commentListState is ActionCommentaireListSuccessState
        ? (store.state.actionCommentaireListState as ActionCommentaireListSuccessState).comments
        : [];
    final commentSendState = store.state.actionCommentaireCreateState;
    final commentDraft = store.state.actionCommentaireCreateState is ActionCommentaireCreateFailureState
        ? (store.state.actionCommentaireCreateState as ActionCommentaireCreateFailureState).comment
        : null;
    return ActionCommentairePageViewModel._(
      comments: commentsList,
      listDisplayState: _commentListDisplayState(commentListState),
      sendDisplayState: _commentSendDisplayState(commentSendState),
      onRetry: () => store.dispatch(ActionCommentaireListRequestAction(userActionId)),
      onSend: (comment) => store.dispatch(ActionCommentaireCreateRequestAction(
        actionId: userActionId,
        comment: comment,
      )),
      errorOnSend: commentSendState is ActionCommentaireCreateFailureState,
      draft: commentDraft,
    );
  }

  @override
  List<Object?> get props => [
        comments,
        listDisplayState,
        sendDisplayState,
        errorOnSend,
        draft,
      ];
}

DisplayState _commentListDisplayState(ActionCommentaireListState state) {
  if (state is ActionCommentaireListFailureState) return DisplayState.erreur;
  if (state is ActionCommentaireListSuccessState) return DisplayState.contenu;
  return DisplayState.chargement;
}

DisplayState _commentSendDisplayState(ActionCommentaireCreateState state) {
  if (state is ActionCommentaireCreateFailureState) return DisplayState.erreur;
  if (state is ActionCommentaireCreateSuccessState) return DisplayState.contenu;
  if (state is ActionCommentaireCreateLoadingState) return DisplayState.chargement;
  return DisplayState.vide;
}
