import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/requests/user_action_update_request.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_store_extension.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class UserActionDoneBottomSheetViewModel extends Equatable {
  final UserActionStateSource source;
  final String userActionId;
  final DisplayState displayState;
  final void Function(DateTime) onActionDone;

  UserActionDoneBottomSheetViewModel({
    required this.source,
    required this.userActionId,
    required this.displayState,
    required this.onActionDone,
  });

  @override
  List<Object?> get props => [
        source,
        userActionId,
        displayState,
      ];

  factory UserActionDoneBottomSheetViewModel.create(
      Store<AppState> store, UserActionStateSource source, String userActionId) {
    final userAction = store.getAction(source, userActionId);

    if (userAction == null) {
      return UserActionDoneBottomSheetViewModel(
        source: source,
        userActionId: userActionId,
        displayState: DisplayState.FAILURE,
        onActionDone: (_) {},
      );
    }
    return UserActionDoneBottomSheetViewModel(
      source: source,
      userActionId: userActionId,
      displayState: _displayState(store.state.userActionUpdateState),
      onActionDone: (dateFin) => store.dispatch(
        UserActionUpdateRequestAction(
          actionId: userActionId,
          request: UserActionUpdateRequest(
            status: UserActionStatus.DONE,
            contenu: userAction.content,
            description: userAction.comment,
            dateEcheance: userAction.dateEcheance,
            type: userAction.type,
            dateFin: dateFin,
          ),
        ),
      ),
    );
  }
}

DisplayState _displayState(UserActionUpdateState state) {
  return switch (state) {
    UserActionUpdateNotInitializedState() => DisplayState.EMPTY,
    UserActionUpdateLoadingState() => DisplayState.LOADING,
    UserActionUpdateSuccessState() => DisplayState.CONTENT,
    UserActionUpdateFailureState() => DisplayState.FAILURE,
  };
}
