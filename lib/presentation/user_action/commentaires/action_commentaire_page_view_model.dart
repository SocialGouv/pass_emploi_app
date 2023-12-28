import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_actions.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_state.dart';
import 'package:pass_emploi_app/models/commentaire.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ActionCommentairePageViewModel extends Equatable {
  final List<Commentaire> comments;
  final DisplayState listDisplayState;
  final Function() onRetry;

  ActionCommentairePageViewModel._({
    required this.comments,
    required this.listDisplayState,
    required this.onRetry,
  });

  factory ActionCommentairePageViewModel.create(Store<AppState> store, String userActionId) {
    final commentListState = store.state.actionCommentaireListState;
    final List<Commentaire> commentsList = commentListState is ActionCommentaireListSuccessState
        ? (store.state.actionCommentaireListState as ActionCommentaireListSuccessState).comments
        : [];
    return ActionCommentairePageViewModel._(
      comments: commentsList,
      listDisplayState: _commentListDisplayState(commentListState),
      onRetry: () => store.dispatch(ActionCommentaireListRequestAction(userActionId)),
    );
  }

  @override
  List<Object?> get props => [
        comments,
        listDisplayState,
      ];
}

DisplayState _commentListDisplayState(ActionCommentaireListState state) {
  if (state is ActionCommentaireListFailureState) return DisplayState.FAILURE;
  if (state is ActionCommentaireListSuccessState) return DisplayState.CONTENT;
  return DisplayState.LOADING;
}
