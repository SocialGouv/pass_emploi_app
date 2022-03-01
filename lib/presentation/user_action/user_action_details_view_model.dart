import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

import '../../models/user_action.dart';

enum UserActionDetailsDisplayState {
  SHOW_CONTENT,
  SHOW_SUCCESS,
  SHOW_LOADING,
  SHOW_DELETE_ERROR,
  TO_DISMISS,
  TO_DISMISS_AFTER_UPDATE,
  TO_DISMISS_AFTER_DELETION
}

class UserActionDetailsViewModel {
  final UserActionDetailsDisplayState displayState;
  final Function(String actionId, UserActionStatus newStatus) onRefreshStatus;
  final Function(String actionId) onDelete;

  factory UserActionDetailsViewModel.create(Store<AppState> store) {
    return UserActionDetailsViewModel._(
      displayState: _displayState(store.state),
      onRefreshStatus: (actionId, newStatus) => _refreshStatus(store, actionId, newStatus),
      onDelete: (actionId) => store.dispatch(UserActionDeleteRequestAction(actionId)),
    );
  }

  UserActionDetailsViewModel._({
    required this.displayState,
    required this.onRefreshStatus,
    required this.onDelete,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserActionDetailsViewModel && runtimeType == other.runtimeType && displayState == other.displayState;

  @override
  int get hashCode => displayState.hashCode;
}

UserActionDetailsDisplayState _displayState(AppState state) {
  final updateState = state.userActionUpdateState;
  if (updateState is UserActionUpdatedState) {
    if (updateState.newStatus == UserActionStatus.DONE) {
      return UserActionDetailsDisplayState.SHOW_SUCCESS;
    } else {
      return UserActionDetailsDisplayState.TO_DISMISS_AFTER_UPDATE;
    }
  } else if (updateState is UserActionNoUpdateNeededState) {
    return UserActionDetailsDisplayState.TO_DISMISS;
  } else if (state.userActionDeleteState is UserActionDeleteSuccessState) {
    return UserActionDetailsDisplayState.TO_DISMISS_AFTER_DELETION;
  } else if (state.userActionDeleteState is UserActionDeleteLoadingState) {
    return UserActionDetailsDisplayState.SHOW_LOADING;
  } else if (state.userActionDeleteState is UserActionDeleteFailureState) {
    return UserActionDetailsDisplayState.SHOW_DELETE_ERROR;
  } else {
    return UserActionDetailsDisplayState.SHOW_CONTENT;
  }
}

void _refreshStatus(Store<AppState> store, String actionId, UserActionStatus newStatus) {
  final loginState = store.state.loginState;
  final userActionListState = store.state.userActionListState;
  if (userActionListState is UserActionListSuccessState) {
    if (loginState.isSuccess()) {
      final action = userActionListState.userActions.firstWhere((e) => e.id == actionId);
      if (action.status != newStatus) {
        store.dispatch(
          UserActionUpdateRequestAction(
            userId: loginState.getResultOrThrow().id,
            actionId: actionId,
            newStatus: newStatus,
          ),
        );
      } else {
        store.dispatch(UserActionNoUpdateNeededAction());
      }
    }
  }
}
