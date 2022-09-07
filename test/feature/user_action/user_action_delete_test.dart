import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../dsl/app_state_dsl.dart';
import '../../utils/test_setup.dart';

void main() {
  test("delete user action when repo succeeds should display loading and then set success state", () async {
    // Given
    final actions = [mockNotStartedAction(actionId: "1"), mockNotStartedAction(actionId: "2")];
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.pageActionRepository = PageActionRepositorySuccessStub();
    final store = testStoreFactory.initializeReduxStore(
      initialState: givenState() //
          .loggedInUser() //
          .agenda(actions: actions) //
          .withActions(actions),
    );
    final displayedLoading = store.onChange.any((e) => e.userActionDeleteState is UserActionDeleteLoadingState);
    final success = store.onChange.firstWhere((e) => e.userActionDeleteState is UserActionDeleteSuccessState);

    // When
    store.dispatch(UserActionDeleteRequestAction("1"));

    // Then
    expect(await displayedLoading, true);
    final successAppState = await success;
    expect(successAppState.userActionDeleteState is UserActionDeleteSuccessState, isTrue);
  });

  test("delete user action when repo succeeds should locally remove action from UserActionListState and AgendaState",
      () async {
    // Given
    final actions = [mockNotStartedAction(actionId: "1"), mockNotStartedAction(actionId: "2")];
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.pageActionRepository = PageActionRepositorySuccessStub();
    final store = testStoreFactory.initializeReduxStore(
      initialState: givenState() //
          .loggedInUser() //
          .agenda(actions: actions) //
          .withActions(actions),
    );
    final displayedLoading = store.onChange.any((e) => e.userActionDeleteState is UserActionDeleteLoadingState);
    final success = store.onChange.firstWhere((e) => e.userActionDeleteState is UserActionDeleteSuccessState);

    // When
    store.dispatch(UserActionDeleteRequestAction("1"));

    // Then
    expect(await displayedLoading, true);
    final successAppState = await success;
    expect(successAppState.userActionListState is UserActionListSuccessState, isTrue);
    expect((successAppState.userActionListState as UserActionListSuccessState).userActions.length, 1);
    expect(successAppState.agendaState is AgendaSuccessState, isTrue);
    expect((successAppState.agendaState as AgendaSuccessState).agenda.actions.length, 1);
  });

  test("delete user action when repo fails should display loading and keep user action", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.pageActionRepository = PageActionRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(
      initialState: givenState()
          .loggedInUser()
          .withActions([mockNotStartedAction(actionId: "1"), mockNotStartedAction(actionId: "2")]),
    );
    final displayedLoading = store.onChange.any((e) => e.userActionDeleteState is UserActionDeleteLoadingState);
    final failure = store.onChange.firstWhere((e) => e.userActionDeleteState is UserActionDeleteFailureState);

    // When
    store.dispatch(UserActionDeleteRequestAction("1"));

    // Then
    expect(await displayedLoading, true);
    final successAppState = await failure;
    expect(successAppState.userActionDeleteState is UserActionDeleteFailureState, isTrue);
    expect(successAppState.userActionListState is UserActionListSuccessState, isTrue);
    expect((successAppState.userActionListState as UserActionListSuccessState).userActions.length, 2);
  });
}
