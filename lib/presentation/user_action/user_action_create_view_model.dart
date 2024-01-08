import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_state.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

sealed class UserActionCreateDisplayState extends Equatable {
  bool get isLoading => this is DisplayLoading;

  @override
  List<Object?> get props => [];
}

class DisplayContent extends UserActionCreateDisplayState {}

class DisplayLoading extends UserActionCreateDisplayState {}

class ShowConfirmationPage extends UserActionCreateDisplayState {
  final String userActionCreatedId;

  ShowConfirmationPage(this.userActionCreatedId);

  @override
  List<Object?> get props => [userActionCreatedId];
}

class DismissWithFailure extends UserActionCreateDisplayState {}

class UserActionCreateViewModel extends Equatable {
  final UserActionCreateDisplayState displayState;
  final Function(UserActionCreateRequest request) createUserAction;

  UserActionCreateViewModel({required this.displayState, required this.createUserAction});

  factory UserActionCreateViewModel.create(Store<AppState> store) {
    return UserActionCreateViewModel(
      displayState: _displayState(store.state.userActionCreateState),
      createUserAction: (request) => store.dispatch(UserActionCreateRequestAction(request)),
    );
  }

  @override
  List<Object?> get props => [displayState];
}

UserActionCreateDisplayState _displayState(UserActionCreateState state) {
  return switch (state) {
    UserActionCreateNotInitializedState() => DisplayContent(),
    UserActionCreateLoadingState() => DisplayLoading(),
    UserActionCreateSuccessState() => ShowConfirmationPage(state.userActionCreatedId),
    UserActionCreateFailureState() => DismissWithFailure(),
  };
}
