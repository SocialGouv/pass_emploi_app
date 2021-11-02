import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_create_state.dart';
import 'package:redux/redux.dart';

enum UserActionAddDisplayState { SHOW_CONTENT, SHOW_LOADING, TO_DISMISS }

class UserActionAddViewModel {
  final Function(String? actionContent, String? actionComment, UserActionStatus initialStatus) createUserAction;

  final UserActionAddDisplayState displayState;

  UserActionAddViewModel({
    required this.displayState,
    required this.createUserAction,
  });

  factory UserActionAddViewModel.create(Store<AppState> store) {
    return UserActionAddViewModel(
      displayState: _displayState(store.state.createUserActionState),
      createUserAction: (content, comment, initialStatus) =>
          {store.dispatch(CreateUserAction(content, comment, initialStatus))},
    );
  }
}

UserActionAddDisplayState _displayState(UserActionCreateState userActionCreateState) {
  if (userActionCreateState is UserActionCreateNotInitializedState) {
    return UserActionAddDisplayState.SHOW_CONTENT;
  } else if (userActionCreateState is CreateUserActionLoadingState) {
    return UserActionAddDisplayState.SHOW_LOADING;
  } else {
    return UserActionAddDisplayState.TO_DISMISS;
  }
}
