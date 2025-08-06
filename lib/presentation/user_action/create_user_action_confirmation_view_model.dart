import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CreateActionSuccessViewModel extends Equatable {
  final String actionId;
  final DisplayState displayState;

  CreateActionSuccessViewModel({
    required this.actionId,
    required this.displayState,
  });

  factory CreateActionSuccessViewModel.create(Store<AppState> store) {
    return CreateActionSuccessViewModel(
      actionId: _actionId(store),
      displayState: _displayState(store),
    );
  }

  @override
  List<Object?> get props => [actionId, displayState];
}

String _actionId(Store<AppState> store) {
  final createState = store.state.userActionCreateState;
  return createState is UserActionCreateSuccessState ? createState.userActionCreatedId : "";
}

DisplayState _displayState(Store<AppState> store) {
  final createState = store.state.userActionCreateState;
  return switch (createState) {
    UserActionCreateNotInitializedState() => DisplayState.LOADING,
    UserActionCreateLoadingState() => DisplayState.LOADING,
    UserActionCreateSuccessState() => DisplayState.CONTENT,
    UserActionCreateFailureState() => DisplayState.FAILURE,
  };
}
