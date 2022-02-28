import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_state.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_create_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

main() {
  test("create when state is loading should set display state to loading", () {
    // Given
    final state = AppState.initialState().copyWith(userActionCreateState: UserActionCreateLoadingState());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = UserActionCreateViewModel.create(store);

    // Then
    expect(viewModel.displayState, UserActionCreateDisplayState.SHOW_LOADING);
  });

  test("create when state is not initialized should set display state to show content", () {
    // Given
    final state = AppState.initialState().copyWith(userActionCreateState: UserActionCreateNotInitializedState());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = UserActionCreateViewModel.create(store);

    // Then
    expect(viewModel.displayState, UserActionCreateDisplayState.SHOW_CONTENT);
  });

  test("create when state is success should set display state to dismiss", () {
    // Given
    final state = AppState.initialState().copyWith(userActionCreateState: UserActionCreateSuccessState());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = UserActionCreateViewModel.create(store);

    // Then
    expect(viewModel.displayState, UserActionCreateDisplayState.TO_DISMISS);
  });

  test('createUserAction should dispatch CreateUserAction', () {
    // Given
    final storeSpy = StoreSpy();
    final state = AppState.initialState();
    final store = Store<AppState>(storeSpy.reducer, initialState: state);
    final viewModel = UserActionCreateViewModel.create(store);

    // When
    viewModel.createUserAction("content", "comment", UserActionStatus.DONE);

    // Then
    expect(storeSpy.calledWithCreate, true);
  });

  test("create when state is failure should display un error", () {
    // Given
    final state = AppState.initialState().copyWith(userActionCreateState: UserActionCreateFailureState());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = UserActionCreateViewModel.create(store);

    // Then
    expect(viewModel.displayState, UserActionCreateDisplayState.SHOW_ERROR);
  });
}

class StoreSpy {
  var calledWithCreate = false;

  AppState reducer(AppState currentState, dynamic action) {
    if (action is UserActionCreateRequestAction) {
      if (action.content == "content" && action.comment == "comment" && action.initialStatus == UserActionStatus.DONE) {
        calledWithCreate = true;
      }
    }
    return currentState;
  }
}
