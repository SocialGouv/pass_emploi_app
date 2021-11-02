import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/reducers/user_action_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_create_state.dart';

main() {
  test("userActionReducer when action is UserActionCreatedWithSuccessAction should set CreateActionState to success", () {
    // Given
    final initialState = AppState.initialState();

    // When
    final updatedState = userActionReducer(
      initialState,
      UserActionCreatedWithSuccessAction("content", "comment"),
    );

    // Then
    expect(updatedState.createUserActionState is CreateUserActionSuccessState, true);
  });
}