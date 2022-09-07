import 'package:clock/clock.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_state.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

enum UserActionCreateDisplayState { SHOW_CONTENT, SHOW_LOADING, TO_DISMISS, SHOW_ERROR }

class UserActionCreateViewModel {
  final UserActionCreateDisplayState displayState;
  final Function(UserActionCreateRequest request) createUserAction;

  UserActionCreateViewModel({required this.displayState, required this.createUserAction});

  factory UserActionCreateViewModel.create(Store<AppState> store) {
    return UserActionCreateViewModel(
      displayState: _displayState(store.state.userActionCreateState),
      createUserAction: (request) => store.dispatch(UserActionCreateRequestAction(request)),
    );
  }

  bool isRappelActive(DateTime? dateEcheance) {
    if (dateEcheance == null) return false;
    return dateEcheance.isAfter(clock.now().add(Duration(days: 3)));
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
