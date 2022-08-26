import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test("delete user action when repo succeeds should display loading and then set success state", () async {
    // Given
    final actions = [mockUserAction(id: "1"), mockUserAction(id: "2")];

    final store = givenState()
        .loggedInUser()
        .agenda(actions: actions, rendezvous: [])
        .withActions(actions)
        .store((factory) => {factory.pageActionRepository = PageActionRepositorySuccessStub()});

    final displayedLoading = store.onChange.any((e) => e.userActionDeleteState is UserActionDeleteLoadingState);
    final success = store.onChange.firstWhere((e) => e.userActionDeleteState is UserActionDeleteSuccessState);

    // When
    store.dispatch(UserActionDeleteRequestAction("1"));

    // Then
    expect(await displayedLoading, true);
    final successAppState = await success;
    expect(successAppState.userActionListState is UserActionListSuccessState, isTrue);
  });

  test("delete from list action should delete user action from actions list & agenda", () async {
    // Given
    final actions = [mockUserAction(id: "1"), mockUserAction(id: "2")];
    final store = givenState()
        .loggedInMiloUser()
        .agenda(actions: actions, rendezvous: [])
        .withActions(actions)
        .deleteActionFromList()
        .store((factory) => {factory.pageActionRepository = PageActionRepositorySuccessStub()});

    final success = store.onChange.firstWhere((e) => e.userActionDeleteState is UserActionDeleteFromListState);

    // When
    store.dispatch(UserActionDeleteFromListAction("1"));

    // Then
    final successAppState = await success;
    expect(successAppState.userActionListState is UserActionListSuccessState, isTrue);
    expect((successAppState.userActionListState as UserActionListSuccessState).userActions.length, 1);
    expect(successAppState.agendaState is AgendaSuccessState, isTrue);
    expect((successAppState.agendaState as AgendaSuccessState).agenda.actions.length, 1);
  });

  test("delete user action when repo fails should display loading and keep user action", () async {
    // Given
    final actions = [mockUserAction(id: "1"), mockUserAction(id: "2")];
    final store = givenState()
        .loggedInMiloUser()
        .withActions(actions)
        .store((factory) => {factory.pageActionRepository = PageActionRepositoryFailureStub()});

    final displayedLoading = store.onChange.any((e) => e.userActionDeleteState is UserActionDeleteLoadingState);
    final failure = store.onChange.firstWhere((e) => e.userActionDeleteState is UserActionDeleteFailureState);

    // When
    store.dispatch(UserActionDeleteRequestAction("1"));

    // Then
    expect(await displayedLoading, true);
    final successAppState = await failure;
    expect(successAppState.userActionListState is UserActionListSuccessState, isTrue);
    expect((successAppState.userActionListState as UserActionListSuccessState).userActions.length, 2);
  });
}
