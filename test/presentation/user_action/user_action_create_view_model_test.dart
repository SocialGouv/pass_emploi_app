import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_state.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_create_view_model.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';

void main() {
  test("create when state is loading should set display state to loading", () {
    // Given
    final state = AppState.initialState().copyWith(userActionCreateState: UserActionCreateLoadingState());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = UserActionCreateViewModel.create(store);

    // Then
    expect(viewModel.displayState, isA<DisplayLoading>());
  });

  test("create when state is not initialized should set display state to show content", () {
    // Given
    final state = AppState.initialState().copyWith(userActionCreateState: UserActionCreateNotInitializedState());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = UserActionCreateViewModel.create(store);

    // Then
    expect(viewModel.displayState, isA<DisplayContent>());
  });

  test("create when state is success should set display state to dismiss", () {
    // Given
    final state = AppState.initialState().copyWith(
      userActionCreateState: UserActionCreateSuccessState('USER-ACTION-ID'),
    );
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = UserActionCreateViewModel.create(store);

    // Then
    expect(viewModel.displayState, isA<DismissWithSuccess>());
    expect((viewModel.displayState as DismissWithSuccess).userActionCreatedId, 'USER-ACTION-ID');
  });

  test("create when state is failure should display an error", () {
    // Given
    final state = AppState.initialState().copyWith(userActionCreateState: UserActionCreateFailureState());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = UserActionCreateViewModel.create(store);

    // Then
    expect(viewModel.displayState, isA<DismissWithFailure>());
  });

  test('createUserAction should dispatch CreateUserAction', () {
    // Given
    final store = StoreSpy();
    final viewModel = UserActionCreateViewModel.create(store);

    // When
    final request = dummyUserActionCreateRequest();
    viewModel.createUserAction(request);

    // Then
    expect(store.dispatchedAction, isA<UserActionCreateRequestAction>());
    expect((store.dispatchedAction as UserActionCreateRequestAction).request, request);
  });
}
