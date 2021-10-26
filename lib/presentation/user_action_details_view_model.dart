import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_update_state.dart';
import 'package:redux/redux.dart';

enum UserActionDetailsDisplayState { SHOW_CONTENT, SHOW_SUCCESS, TO_DISMISS }

class UserActionDetailsViewModel {
  final UserActionDetailsDisplayState displayState;

  factory UserActionDetailsViewModel.create(Store<AppState> store) {
    return UserActionDetailsViewModel._(
      displayState: _displayState(store.state),
    );
  }

  UserActionDetailsViewModel._({
    required this.displayState,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserActionDetailsViewModel && runtimeType == other.runtimeType && displayState == other.displayState;

  @override
  int get hashCode => displayState.hashCode;
}

UserActionDetailsDisplayState _displayState(AppState state) {
  if (state.userActionUpdateState is UserActionUpdatedState) {
    return UserActionDetailsDisplayState.SHOW_SUCCESS;
  } else if (state.userActionUpdateState is UserActionNoUpdateNeeded) {
    return UserActionDetailsDisplayState.TO_DISMISS;
  } else {
    return UserActionDetailsDisplayState.SHOW_CONTENT;
  }
}
