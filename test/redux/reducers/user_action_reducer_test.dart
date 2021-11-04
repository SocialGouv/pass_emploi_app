import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/reducers/user_action_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/create_user_action_state.dart';

main() {

  test("userActionReducer when action is UserActionCreatedWithSuccessAction should set CreateActionState to success", () {
    // Given
    final initialState = AppState.initialState();

    // When
    final updatedState = userActionReducer(
      initialState,
      UserActionCreatedWithSuccessAction(),
    );

    // Then
    expect(updatedState.createUserActionState is CreateUserActionSuccessState, true);
  });

  test("userActionReducer when action is UserActionCreatedFailed should set CreateActionState to error", () {
    // Given
    final initialState = AppState.initialState();

    // When
    final updatedState = userActionReducer(
      initialState,
      UserActionCreationFailed(),
    );

    // Then
    expect(updatedState.createUserActionState is CreateUserActionErrorState, true);
  });

}