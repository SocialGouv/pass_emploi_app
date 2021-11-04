import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/create_user_action_view_model.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/create_user_action_state.dart';
import 'package:redux/redux.dart';

main() {
  test("create when state is loading should set display state to loading", () {
    // Given
    final state = AppState.initialState().copyWith(createUserActionState: CreateUserActionState.loading());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = CreateUserActionViewModel.create(store);

    // Then
    expect(viewModel.displayState, CreateUserActionDisplayState.SHOW_LOADING);
  });

  test("create when state is not initialized should set display state to show content", () {
    // Given
    final state = AppState.initialState().copyWith(createUserActionState: CreateUserActionState.notInitialized());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = CreateUserActionViewModel.create(store);

    // Then
    expect(viewModel.displayState, CreateUserActionDisplayState.SHOW_CONTENT);
  });

  test("create when state is success should set display state to dismiss", () {
    // Given
    final state = AppState.initialState().copyWith(createUserActionState: CreateUserActionState.success());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = CreateUserActionViewModel.create(store);

    // Then
    expect(viewModel.displayState, CreateUserActionDisplayState.TO_DISMISS);
  });

  test('createUserAction should dispatch CreateUserAction', () {
    // Given
    final storeSpy = StoreSpy();
    final state = AppState.initialState();
    final store = Store<AppState>(storeSpy.reducer, initialState: state);
    final viewModel = CreateUserActionViewModel.create(store);

    // When
    viewModel.createUserAction("content", "comment", UserActionStatus.DONE);

    // Then
    expect(storeSpy.calledWithCreate, true);
  });

  test("create when state is error should display un error", () {
    // Given
    final state = AppState.initialState().copyWith(createUserActionState: CreateUserActionState.error());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = CreateUserActionViewModel.create(store);

    // Then
    expect(viewModel.displayState, CreateUserActionDisplayState.SHOW_ERROR);
  });

}

class StoreSpy {
  var calledWithCreate = false;

  AppState reducer(AppState currentState, dynamic action) {
    if (action is CreateUserAction) {
      if (action.content == "content" && action.comment == "comment" && action.initialStatus ==  UserActionStatus.DONE) {
        calledWithCreate = true;
      }
    }
    return currentState;
  }
}
