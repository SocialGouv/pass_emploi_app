import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';

import '../doubles/fixtures.dart';
import '../doubles/stubs.dart';
import '../utils/test_setup.dart';

void main() {
  test("actions should be fetched and displayed when screen loads", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.userActionRepository = UserActionRepositorySuccessStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

    final displayedLoading = store.onChange.any((element) => element.userActionState.isLoading());
    final successAppState = store.onChange.firstWhere((element) => element.userActionState.isSuccess());

    // When
    await store.dispatch(RequestUserActionsAction());

    // Then
    expect(await displayedLoading, true);
    final appState = await successAppState;
    expect(appState.userActionState.getDataOrThrow().length, 1);
    expect(appState.userActionState.getDataOrThrow()[0].id, "id");
  });
}
