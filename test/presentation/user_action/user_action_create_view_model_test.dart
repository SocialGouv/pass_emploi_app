import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_state.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_create_view_model.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../../doubles/spies.dart';

void main() {
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
    final store = StoreSpy();
    final viewModel = UserActionCreateViewModel.create(store);

    // When
    final request = UserActionCreateRequest("content", "comment", DateTime(2022), UserActionStatus.DONE);
    viewModel.createUserAction(request);

    // Then
    expect(store.dispatchedAction, isA<UserActionCreateRequestAction>());
    expect((store.dispatchedAction as UserActionCreateRequestAction).request, request);
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
