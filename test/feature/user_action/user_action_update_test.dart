import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/page_action_repository.dart';
import 'package:redux/redux.dart';

import '../../doubles/dummies.dart';
import '../../dsl/app_state_dsl.dart';
import '../../utils/test_setup.dart';

void main() {

  test("an unedited action should not update the list", () async {
    // Given
    final reducerSpy = _UpdateActionReducerSpy();
    final store = Store<AppState>(
        reducerSpy.reducer,
        initialState: givenState().loggedInUser().copyWith(
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

    // When
    await store.dispatch(
      UserActionUpdateRequestAction(
        actionId: "3",
        newStatus: UserActionStatus.NOT_STARTED,
      ),
    );

    expect(reducerSpy.updateWasCalled, false);
  });

  test("an edited action should be updated and on top of the list", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    final repositorySpy = PageActionRepositorySpy();
    testStoreFactory.pageActionRepository = repositorySpy;
    final store = testStoreFactory.initializeReduxStore(
      initialState: givenState().loggedInUser().copyWith(
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

class _UpdateActionReducerSpy {
  var updateWasCalled = false;

  AppState reducer(AppState currentState, dynamic action) {
    if (action is UserActionUpdateNeededAction) {
      updateWasCalled = true;
    }
    return currentState;
  }
}

