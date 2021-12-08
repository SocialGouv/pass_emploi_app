import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/reducers/user_action_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/create_user_action_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_update_state.dart';

main() {
  test("userActionReducer when action is UserActionCreatedWithSuccessAction should set CreateActionState to success",
      () {
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

  test(
      "userActionReducer when action is UpdateActionStatus with different status should update action and actionUpdate states",
      () {
    // Given
    final initialState = AppState.initialState().copyWith(
      userActionState: UserActionState.success(
        [_notStartedAction()],
      ),
    );

    // When
    final updatedState = userActionReducer(
      initialState,
      UserActionUpdateStatusAction(
        userId: "userId",
        actionId: "actionId",
        newStatus: UserActionStatus.DONE,
      ),
    );

    // Then
    final actionState = updatedState.userActionState as UserActionSuccessState;
    expect(actionState.actions[0].id, "actionId");
    expect(actionState.actions[0].status, UserActionStatus.DONE);

    expect(updatedState.userActionUpdateState is UserActionUpdatedState, true);
  });
}

UserAction _notStartedAction() {
  return UserAction(
    id: "actionId",
    content: "content",
    comment: "comment",
    status: UserActionStatus.NOT_STARTED,
    lastUpdate: DateTime(2022, 12, 23, 0, 0, 0),
    creator: JeuneActionCreator(),
  );
}
