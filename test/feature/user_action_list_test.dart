import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_actions.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';

import '../doubles/fixtures.dart';
import '../doubles/stubs.dart';
import '../utils/test_setup.dart';

void main() {
  test("actions should be fetched and displayed when screen loads", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.userActionRepository = UserActionRepositorySuccessStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

    final displayedLoading = store.onChange.any((e) => e.userActionListState is UserActionListLoadingState);
    final successAppState = store.onChange.firstWhere((e) => e.userActionListState is UserActionListSuccessState);

    // When
    await store.dispatch(UserActionListRequestAction());

    // Then
    expect(await displayedLoading, true);
    final appState = await successAppState;
    expect(appState.userActionListState is UserActionListSuccessState, isTrue);
    expect((appState.userActionListState as UserActionListSuccessState).userActions.length, 1);
    expect((appState.userActionListState as UserActionListSuccessState).userActions[0].id, "id");
  });
}
