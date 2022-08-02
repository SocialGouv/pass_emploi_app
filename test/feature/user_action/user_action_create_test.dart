import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/models/user_action.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../utils/test_setup.dart';

void main() {
  test("create user action when repo succeeds should display loading and then create user action", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.pageActionRepository = PageActionRepositorySuccessStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());
    final displayedLoading = store.onChange.any((e) => e.userActionCreateState is UserActionCreateLoadingState);
    final success = store.onChange.firstWhere((e) => e.userActionCreateState is UserActionCreateSuccessState);

    // When
    store.dispatch(UserActionCreateRequestAction(_request()));

    // Then
    expect(await displayedLoading, true);
    final successAppState = await success;
    expect(successAppState.userActionCreateState is UserActionCreateSuccessState, isTrue);
  });

  test("create user action when repo succeeds refresh user user_action", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.pageActionRepository = PageActionRepositorySuccessStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());
    final displayedLoading = store.onChange.any((e) => e.userActionListState is UserActionListLoadingState);
    final success = store.onChange.firstWhere((e) => e.userActionListState is UserActionListSuccessState);

    // When
    store.dispatch(UserActionCreateRequestAction(_request()));

    // Then
    expect(await displayedLoading, true);
    final successAppState = await success;
    expect(successAppState.userActionListState is UserActionListSuccessState, isTrue);
    expect((successAppState.userActionListState as UserActionListSuccessState).userActions, isNotEmpty);
  });

  test("create user action when repo fails should display loading and then show failure", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.pageActionRepository = PageActionRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());
    final displayedLoading = store.onChange.any((e) => e.userActionCreateState is UserActionCreateLoadingState);
    final failure = store.onChange.firstWhere((e) => e.userActionCreateState is UserActionCreateFailureState);

    // When
    store.dispatch(UserActionCreateRequestAction(_request()));

    // Then
    expect(await displayedLoading, true);
    final failureAppState = await failure;
    expect(failureAppState.userActionCreateState is UserActionCreateFailureState, isTrue);
  });
}

UserActionCreateRequest _request() {
  return UserActionCreateRequest(
    "content",
    "comment",
    DateTime.now(),
    true,
    UserActionStatus.NOT_STARTED,
  );
}
