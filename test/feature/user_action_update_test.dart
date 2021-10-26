import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_update_state.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';

import '../doubles/dummies.dart';
import '../utils/test_setup.dart';

void main() {
  test("when user requests an update the action should be updated and user notified", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    final repositorySpy = UserActionRepositorySpy();
    testStoreFactory.userActionRepository = repositorySpy;
    final store = testStoreFactory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        userActionState: UserActionState.success(
          [_notStartedAction()],
        ),
      ),
    );

    final changedState = store.onChange.first;

    // When
    await store.dispatch(UpdateActionStatus(
      userId: "userId",
      actionId: "actionId",
      newStatus: UserActionStatus.DONE,
    ));

    // Then
    final appState = await changedState;
    final actionState = appState.userActionState as UserActionSuccessState;
    expect(repositorySpy.isActionUpdated, true);

    expect(actionState.actions[0].id, "actionId");
    expect(actionState.actions[0].status, UserActionStatus.DONE);

    expect(appState.userActionUpdateState is UserActionUpdatedState, true);
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

class UserActionRepositorySpy extends UserActionRepository {
  var isActionUpdated = false;

  UserActionRepositorySpy() : super("", DummyHeadersBuilder());

  @override
  Future<List<UserAction>?> getUserActions(String userId) async {
    return [];
  }

  @override
  Future<void> updateActionStatus(String userId, String actionId, UserActionStatus newStatus) async {
    isActionUpdated = true;
  }
}
