import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/page_action_repository.dart';

import '../../doubles/dummies.dart';
import '../../utils/test_setup.dart';

void main() {
  test("when user requests an update the action should be updated, put on top of list and user notified", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    final repositorySpy = PageActionRepositorySpy();
    testStoreFactory.pageActionRepository = repositorySpy;
    final store = testStoreFactory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        userActionListState: UserActionListSuccessState(
          [
            _notStartedAction(actionId: "1"),
            _notStartedAction(actionId: "2"),
            _notStartedAction(actionId: "3"),
            _notStartedAction(actionId: "4"),
          ],
        ),
      ),
    );

    final successAppState = store.onChange.firstWhere((e) => e.userActionUpdateState is UserActionUpdatedState);

    // When
    await store.dispatch(
      UserActionUpdateRequestAction(
        userId: "userId",
        actionId: "3",
        newStatus: UserActionStatus.DONE,
      ),
    );

    // Then
    final appState = await successAppState;
    expect(repositorySpy.isActionUpdated, true);

    expect(appState.userActionListState is UserActionListSuccessState, isTrue);
    expect((appState.userActionListState as UserActionListSuccessState).userActions[0].id, "3");
    expect((appState.userActionListState as UserActionListSuccessState).userActions[0].status, UserActionStatus.DONE);
    expect(appState.userActionUpdateState is UserActionUpdatedState, isTrue);
  });
}

UserAction _notStartedAction({required String actionId}) {
  return UserAction(
    id: actionId,
    content: "content",
    comment: "comment",
    status: UserActionStatus.NOT_STARTED,
    lastUpdate: DateTime(2022, 12, 23, 0, 0, 0),
    dateEcheance: DateTime(2042),
    creator: JeuneActionCreator(),
  );
}

class PageActionRepositorySpy extends PageActionRepository {
  var isActionUpdated = false;

  PageActionRepositorySpy() : super("", DummyHttpClient());

  @override
  Future<void> updateActionStatus(String userId, String actionId, UserActionStatus newStatus) async {
    isActionUpdated = true;
  }
}
