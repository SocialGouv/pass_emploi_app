import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/user_action.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test("update action when repo succeeds should display loading and then update action", () async {
    // Given
    final repository = PageActionRepositorySuccessStub();
    final store = givenState()
        .loggedInMiloUser()
        .store((factory) => {factory.pageActionRepository = repository)});

    // When
    await store.dispatch(
      UserActionUpdateRequestAction(
        actionId: "3",
        newStatus: UserActionStatus.NOT_STARTED,
      ),
    );

    expect(repository.updateWasCalled, false);
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

    final updateDisplayedLoading = store.onChange.any((e) => e.userActionUpdateState is UserActionUpdateLoadingState);
    final successUpdateState =
        store.onChange.firstWhere((e) => e.userActionUpdateState is UserActionUpdateSuccessState);

    // When
    await store.dispatch(UserActionUpdateRequestAction(actionId: "3", newStatus: UserActionStatus.DONE));

    // Then
    expect(await updateDisplayedLoading, isTrue);
    final successUpdate = await successUpdateState;
    expect(successUpdate.userActionUpdateState is UserActionUpdateSuccessState, isTrue);
  });

  test("when user requests an update the action should be updated, put on top of list and user notified", () async {
    // Given
    final repository = PageActionRepositorySuccessStub();
    final store = givenState().loggedInMiloUser().withActions(
      [
        mockNotStartedAction(actionId: "1"),
        mockNotStartedAction(actionId: "2"),
        mockNotStartedAction(actionId: "3"),
        mockNotStartedAction(actionId: "4"),
      ],
    ).store((factory) => {factory.pageActionRepository = repository});

    final successAppState = store.onChange.firstWhere((e) => e.userActionUpdateState is UserActionUpdateSuccessState);

    // When
    await store.dispatch(UserActionUpdateRequestAction(actionId: "3", newStatus: UserActionStatus.DONE));

    // Then
    final appState = await successAppState;
    expect(repository.isActionUpdated, isTrue);

    expect(appState.userActionUpdateState is UserActionUpdateSuccessState, isTrue);
    expect((appState.userActionListState as UserActionListSuccessState).userActions[0].id, "3");
    expect((appState.userActionListState as UserActionListSuccessState).userActions[0].status, UserActionStatus.DONE);
  });

  test("when user requests an update the action should be updated, put on top of list and user notified", () async {
    // Given
    final repository = PageActionRepositorySuccessStub();
    final store = givenState().loggedInMiloUser().withActions(
      [
        mockNotStartedAction(actionId: "1"),
        mockNotStartedAction(actionId: "2"),
        mockNotStartedAction(actionId: "3"),
        mockNotStartedAction(actionId: "4"),
      ],
    ).store((factory) => {factory.pageActionRepository = repository});

    final successAppState = store.onChange.firstWhere((e) => e.userActionUpdateState is UserActionUpdateSuccessState);

    // When
    await store.dispatch(UserActionUpdateRequestAction(actionId: "3", newStatus: UserActionStatus.DONE));

    // Then
    final appState = await successAppState;
    expect(repository.isActionUpdated, isTrue);

    expect(appState.userActionUpdateState is UserActionUpdateSuccessState, isTrue);
    expect((appState.userActionListState as UserActionListSuccessState).userActions[0].id, "3");
    expect((appState.userActionListState as UserActionListSuccessState).userActions[0].status, UserActionStatus.DONE);
  });


  test("update action when repo fails should display loading and then show failure", () async {
    // Given
    final repository = PageActionRepositoryFailureStub();
    final store = givenState().loggedInMiloUser().store((factory) => {factory.pageActionRepository = repository});

    final updateDisplayedLoading = store.onChange.any((e) => e.userActionUpdateState is UserActionUpdateLoadingState);
    final failureUpdateState =
        store.onChange.firstWhere((e) => e.userActionUpdateState is UserActionUpdateFailureState);

    // When
    await store.dispatch(UserActionUpdateRequestAction(actionId: "3", newStatus: UserActionStatus.DONE));

    // Then
    expect(await updateDisplayedLoading, isTrue);
    expect(repository.isActionUpdated, isFalse);

    final failureUpdate = await failureUpdateState;
    expect(failureUpdate.userActionUpdateState is UserActionUpdateFailureState, isTrue);
  });

  test("update action when repo fails should not update actions' list", () async {
    // Given
    final repository = PageActionRepositoryFailureStub();
    final store = givenState().loggedInMiloUser().withActions(
      [
        mockNotStartedAction(actionId: "1"),
        mockNotStartedAction(actionId: "2"),
        mockNotStartedAction(actionId: "3"),
        mockNotStartedAction(actionId: "4"),
      ],
    ).store((factory) => {factory.pageActionRepository = repository});

    final failureUpdateState =
        store.onChange.firstWhere((e) => e.userActionUpdateState is UserActionUpdateFailureState);

    // When
    await store.dispatch(UserActionUpdateRequestAction(actionId: "3", newStatus: UserActionStatus.DONE));

    // Then

    final appState = await failureUpdateState;
    expect(repository.isActionUpdated, isFalse);

    expect(appState.userActionUpdateState is UserActionUpdateFailureState, isTrue);
    expect((appState.userActionListState as UserActionListSuccessState).userActions[2].id, "3");
    expect(
      (appState.userActionListState as UserActionListSuccessState).userActions[2].status,
      UserActionStatus.NOT_STARTED,
    );
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
