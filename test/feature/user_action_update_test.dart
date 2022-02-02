import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:pass_emploi_app/redux/states/user_action_update_state.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';

import '../doubles/dummies.dart';
import '../utils/test_setup.dart';

void main() {
  test("when user requests an update the action should be updated, put on top of list and user notified", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    final repositorySpy = UserActionRepositorySpy();
    testStoreFactory.userActionRepository = repositorySpy;
    final store = testStoreFactory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        userActionState: State<List<UserAction>>.success(
          [
            _notStartedAction(actionId: "1"),
            _notStartedAction(actionId: "2"),
            _notStartedAction(actionId: "3"),
            _notStartedAction(actionId: "4"),
          ],
        ),
      ),
    );

    final changedState = store.onChange.first;

    // When
    await store.dispatch(UserActionUpdateStatusAction(
      userId: "userId",
      actionId: "3",
      newStatus: UserActionStatus.DONE,
    ));

    // Then
    final appState = await changedState;
    expect(repositorySpy.isActionUpdated, true);

    expect(appState.userActionState.getResultOrThrow()[0].id, "3");
    expect(appState.userActionState.getResultOrThrow()[0].status, UserActionStatus.DONE);

    expect(appState.userActionUpdateState is UserActionUpdatedState, true);
  });
}

UserAction _notStartedAction({required String actionId}) {
  return UserAction(
    id: actionId,
    content: "content",
    comment: "comment",
    status: UserActionStatus.NOT_STARTED,
    lastUpdate: DateTime(2022, 12, 23, 0, 0, 0),
    creator: JeuneActionCreator(),
  );
}

class UserActionRepositorySpy extends UserActionRepository {
  var isActionUpdated = false;

  UserActionRepositorySpy() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<List<UserAction>?> getUserActions(String userId) async => [];

  @override
  Future<void> updateActionStatus(String userId, String actionId, UserActionStatus newStatus) async {
    isActionUpdated = true;
  }
}
