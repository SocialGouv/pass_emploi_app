import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_state.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

sealed class UserActionCreateDisplayState {
  bool get isLoading => this is DisplayLoading;
}

class DisplayContent extends UserActionCreateDisplayState {}

class DisplayLoading extends UserActionCreateDisplayState {}

class DismissWithSuccess extends UserActionCreateDisplayState {
  final String userActionCreatedId;

  DismissWithSuccess(this.userActionCreatedId);
}

class DismissWithFailure extends UserActionCreateDisplayState {}

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
}

UserActionCreateDisplayState _displayState(UserActionCreateState state) {
  return switch (state) {
    UserActionCreateNotInitializedState() => DisplayContent(),
    UserActionCreateLoadingState() => DisplayLoading(),
    UserActionCreateSuccessState() => DismissWithSuccess(state.userActionCreatedId),
    UserActionCreateFailureState() => DismissWithFailure(),
  };
}
