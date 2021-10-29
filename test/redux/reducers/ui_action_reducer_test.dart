import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/reducers/ui_action_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_create_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_update_state.dart';

main() {
  test("uiActionReducer when action is not handled should leave state untouched", () {
    // Given
    final initialState = AppState.initialState();

    // When
    final updatedState = uiActionReducer(initialState, LogoutAction());

    // Then
    expect(updatedState, initialState);
  });

  test(
      "uiActionReducer when action is UpdateActionStatus with different status should update action and actionUpdate states",
      () {
    // Given
    final initialState = AppState.initialState().copyWith(
      userActionState: UserActionState.success(
        [_notStartedAction()],
      ),
    );

    // When
    final updatedState = uiActionReducer(
      initialState,
      UpdateActionStatus(
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

  test("uiActionReducer when action is DismissUserActionDetailsAction should reset actionUpdate state", () {
    // Given
    final initialState = AppState.initialState().copyWith(
      userActionState: UserActionState.success(
        [_notStartedAction()],
      ),
      userActionUpdateState: UserActionUpdateState.updated(),
    );

    // When
    final updatedState = uiActionReducer(
      initialState,
      DismissUserActionDetailsAction(),
    );

    // Then
    expect(updatedState.userActionUpdateState is UserActionNotUpdatingState, true);
  });

  test("uiActionReducer when action is UserActionNoUpdateNeededAction should set update action update state", () {
    // Given
    final initialState = AppState.initialState().copyWith(
      userActionState: UserActionState.success(
        [_notStartedAction()],
      ),
      userActionUpdateState: UserActionUpdateState.updated(),
    );

    // When
    final updatedState = uiActionReducer(
      initialState,
      UserActionNoUpdateNeededAction(),
    );

    // Then
    expect(updatedState.userActionUpdateState is UserActionNoUpdateNeeded, true);
  });

  test("uiActionReducer when action is CreateUserAction should set CreateActionState to loading", () {
    // Given
    final initialState = AppState.initialState();

    // When
    final updatedState = uiActionReducer(
      initialState,
      CreateUserAction("content", "comment", UserActionStatus.DONE),
    );

    // Then
    expect(updatedState.createUserActionState is CreateUserActionLoadingState, true);
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
