import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_state.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

enum UserActionCreateDisplayState { SHOW_CONTENT, SHOW_LOADING, TO_DISMISS, SHOW_ERROR }

class UserActionCreateViewModel {
  final Function(String actionContent, String? actionComment, UserActionStatus initialStatus) createUserAction;

  final UserActionCreateDisplayState displayState;

  UserActionCreateViewModel({required this.displayState, required this.createUserAction});

  factory UserActionCreateViewModel.create(Store<AppState> store) {
    return UserActionCreateViewModel(
      displayState: _displayState(store.state.userActionCreateState),
      createUserAction: (content, comment, initialStatus) {
        return store.dispatch(UserActionCreateRequestAction(content, comment, initialStatus));
      },
    );
  }
}

UserActionCreateDisplayState _displayState(UserActionCreateState state) {
  if (state is UserActionCreateNotInitializedState) {
    return UserActionCreateDisplayState.SHOW_CONTENT;
  } else if (state is UserActionCreateLoadingState) {
    return UserActionCreateDisplayState.SHOW_LOADING;
  } else if (state is UserActionCreateSuccessState) {
    return UserActionCreateDisplayState.TO_DISMISS;
  } else {
    return UserActionCreateDisplayState.SHOW_ERROR;
  }
}
