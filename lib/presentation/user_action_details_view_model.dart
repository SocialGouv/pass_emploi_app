import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_update_state.dart';
import 'package:redux/redux.dart';

enum UserActionDetailsState { SHOW_CONTENT, SHOW_SUCCESS }

class UserActionDetailsViewModel {
  final UserActionDetailsState displayState;

  factory UserActionDetailsViewModel.create(Store<AppState> store) {
    return UserActionDetailsViewModel._(
      displayState: _lol(store.state),
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

UserActionDetailsState _lol(AppState state) {
  if (state.userActionUpdateState is UserActionUpdatedState) {
    return UserActionDetailsState.SHOW_SUCCESS;
  } else {
    return UserActionDetailsState.SHOW_CONTENT;
  }
}
