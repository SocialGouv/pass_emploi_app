import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/user_action.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../dsl/app_state_dsl.dart';
import '../../utils/expects.dart';
import '../../utils/test_setup.dart';

void main() {
  test("update action when repo succeeds should display loading and then succeed", () async {
    // Given
    final store = givenState()
        .loggedInMiloUser()
        .withAction(mockUserAction(id: "3"))
        .store((factory) => {factory.pageActionRepository = PageActionRepositorySuccessStub()});

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

  test("update action when repo fails should display loading and then show failure", () async {
    // Given
    final repository = PageActionRepositoryFailureStub();
    final store = givenState()
        .loggedInMiloUser()
        .withAction(mockUserAction(id: "3"))
        .store((factory) => {factory.pageActionRepository = repository});

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

  group("an edited action contained in user action list but not in agenda", () {
    final actions = [mockNotStartedAction(actionId: "3")];

    final state = givenState() //
        .loggedInUser() //
        .agenda() //
        .withActions(actions);

    final testStoreFactory = TestStoreFactory();
    final repository = PageActionRepositorySuccessStub();
    testStoreFactory.pageActionRepository = repository;
    final store = testStoreFactory.initializeReduxStore(initialState: state);

    void whenUpdatingAction() async {
      await store.dispatch(UserActionUpdateRequestAction(actionId: "3", newStatus: UserActionStatus.DONE));
    }

    test("should update on repository", () async {
      // When
      whenUpdatingAction();

      // Then
      expect(repository.isActionUpdated, isTrue);
    });

    test("should update on user action update state", () async {
      final successAppState = store.onChange.firstWhere((e) => e.userActionUpdateState is UserActionUpdateSuccessState);

      // When
      whenUpdatingAction();

      // Then
      final appState = await successAppState;
      expect(appState.userActionUpdateState is UserActionUpdateSuccessState, isTrue);
    });

    test("should update on user action list state", () async {
      final successAppState = store.onChange.firstWhere((e) => e.userActionListState is UserActionListSuccessState);

      // When
      whenUpdatingAction();

      // Then
      final appState = await successAppState;
      expect(appState.userActionListState is UserActionListSuccessState, isTrue);
      expect((appState.userActionListState as UserActionListSuccessState).userActions[0].id, "3");
      expect((appState.userActionListState as UserActionListSuccessState).userActions[0].status, UserActionStatus.DONE);
    });

    test("should keep the same agenda state", () async {
      final successAppState = store.onChange.firstWhere((e) => e.agendaState is AgendaSuccessState);

      // When
      whenUpdatingAction();

      // Then
      final appState = await successAppState;
      expectTypeThen<AgendaSuccessState>(appState.agendaState, (agendaState) {
        expect(agendaState.agenda.actions.isEmpty, true);
      });
    });
  });

  group("an edited action should be updated", () {
    final actions = [
      mockNotStartedAction(actionId: "1"),
      mockNotStartedAction(actionId: "2"),
      mockNotStartedAction(actionId: "3"),
      mockNotStartedAction(actionId: "4"),
    ];

    final state = givenState() //
        .loggedInUser()
        .agenda(actions: actions) //
        .withActions(actions);

    final testStoreFactory = TestStoreFactory();
    final repository = PageActionRepositorySuccessStub();
    testStoreFactory.pageActionRepository = repository;
    final store = testStoreFactory.initializeReduxStore(initialState: state);

    void whenUpdatingAction() async {
      await store.dispatch(UserActionUpdateRequestAction(actionId: "3", newStatus: UserActionStatus.DONE));
    }

    test("on repository", () async {
      // When
      whenUpdatingAction();

      // Then
      expect(repository.isActionUpdated, isTrue);
    });

    test("on user action update state", () async {
      final successAppState = store.onChange.firstWhere((e) => e.userActionUpdateState is UserActionUpdateSuccessState);

      // When
      whenUpdatingAction();

      // Then
      final appState = await successAppState;
      expect(appState.userActionUpdateState is UserActionUpdateSuccessState, isTrue);
    });

    test("on user action list state", () async {
      final successAppState = store.onChange.firstWhere((e) => e.userActionListState is UserActionListSuccessState);

      // When
      whenUpdatingAction();

      // Then
      final appState = await successAppState;
      expect(appState.userActionListState is UserActionListSuccessState, isTrue);
      expect((appState.userActionListState as UserActionListSuccessState).userActions[0].id, "3");
      expect((appState.userActionListState as UserActionListSuccessState).userActions[0].status, UserActionStatus.DONE);
    });

    test("on agenda state", () async {
      final successAppState = store.onChange.firstWhere((e) => e.agendaState is AgendaSuccessState);

      // When
      whenUpdatingAction();

      // Then
      final appState = await successAppState;
      expectTypeThen<AgendaSuccessState>(appState.agendaState, (agendaState) {
        expect(agendaState.agenda.actions[0].id, "3");
        expect(agendaState.agenda.actions[0].status, UserActionStatus.DONE);
      });
    });
  });
}
