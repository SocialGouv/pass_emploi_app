import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/user_action_state.dart';

import '../doubles/stubs.dart';
import '../utils/test_setup.dart';

void main() {
  test("actions should be fetched and displayed when screen loads", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.userActionRepository = UserActionRepositorySuccessStub();
    final store = testStoreFactory.initializeReduxStore();

    final displayedLoading = store.onChange.any((element) => element.userActionState is UserActionLoadingState);
    final successAppState = store.onChange.firstWhere((element) => element.userActionState is UserActionSuccessState);

    // When
    await store.dispatch(RequestUserActionsAction("1234"));

    // Then
    expect(await displayedLoading, true);
    final appState = await successAppState;
    expect((appState.userActionState as UserActionSuccessState).actions.length, 1);
    expect((appState.userActionState as UserActionSuccessState).actions[0].id, "id");
  });
}