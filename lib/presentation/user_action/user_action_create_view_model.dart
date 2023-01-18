import 'package:clock/clock.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_state.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

abstract class UserActionCreateDisplayState {}

class DisplayContent extends UserActionCreateDisplayState {}

class DisplayLoading extends UserActionCreateDisplayState {}

class Dismiss extends UserActionCreateDisplayState {
  final String userActionCreatedId;

  Dismiss(this.userActionCreatedId);
}

class DisplayError extends UserActionCreateDisplayState {}

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
    return dateEcheance != null ? dateEcheance.isAfter(clock.now().add(Duration(days: 3))) : false;
  }
}

UserActionCreateDisplayState _displayState(UserActionCreateState state) {
  if (state is UserActionCreateNotInitializedState) return DisplayContent();
  if (state is UserActionCreateLoadingState) return DisplayLoading();
  if (state is UserActionCreateSuccessState) return Dismiss(state.userActionCreatedId);
  return DisplayError();
}
