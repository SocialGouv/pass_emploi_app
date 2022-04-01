import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_actions.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../utils/test_setup.dart';

void main() {
  test("actions PE should be fetched and displayed when screen loads", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.userActionPERepository = UserActionPERepositorySuccessStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInPoleEmploiState());

    final displayedLoading = store.onChange.any((e) => e.userActionPEListState is UserActionPEListLoadingState);
    final successAppState = store.onChange.firstWhere((e) => e.userActionPEListState is UserActionPEListSuccessState);

    // When
    await store.dispatch(UserActionPEListRequestAction());

    // Then
    expect(await displayedLoading, true);
    final appState = await successAppState;
    expect(appState.userActionPEListState is UserActionPEListSuccessState, isTrue);
    expect((appState.userActionPEListState as UserActionPEListSuccessState).userActions.length, 1);
    expect((appState.userActionPEListState as UserActionPEListSuccessState).userActions[0].id, "id");
  });
}