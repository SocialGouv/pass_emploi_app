import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_delete_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_state.dart';

import '../doubles/stubs.dart';
import '../utils/test_setup.dart';

main() {
  test("delete user action when repo succeeds should display loading and then delete user action", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.userActionRepository = UserActionRepositorySuccessStub();
    final store = testStoreFactory.initializeReduxStore(
        initialState: AppState.initialState().copyWith(userActionState: UserActionState.success(_userActions())));

    final displayedLoading =
        store.onChange.any((element) => element.userActionDeleteState is UserActionDeleteLoadingState);
    final success =
        store.onChange.firstWhere((element) => element.userActionDeleteState is UserActionDeleteSuccessState);

    // When
    store.dispatch(UserActionDeleteAction("1"));

    // Then
    expect(await displayedLoading, true);
    final successAppState = await success;
    expect((successAppState.userActionState as UserActionSuccessState).actions.length, 1);
  });

  test("delete user action when repo fails should display loading and keep user action", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.userActionRepository = UserActionRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(
        initialState: AppState.initialState().copyWith(userActionState: UserActionState.success(_userActions())));

    final displayedLoading =
        store.onChange.any((element) => element.userActionDeleteState is UserActionDeleteLoadingState);
    final failure =
        store.onChange.firstWhere((element) => element.userActionDeleteState is UserActionDeleteFailureState);

    // When
    store.dispatch(UserActionDeleteAction("1"));

    // Then
    expect(await displayedLoading, true);
    final successAppState = await failure;
    expect((successAppState.userActionState as UserActionSuccessState).actions.length, 2);
  });
}

List<UserAction> _userActions() {
  return [
    UserAction(
      id: "1",
      content: "content",
      comment: "comment",
      status: UserActionStatus.NOT_STARTED,
      lastUpdate: DateTime(2022, 12, 23, 0, 0, 0),
      creator: JeuneActionCreator(),
    ),
    UserAction(
      id: "2",
      content: "content",
      comment: "comment",
      status: UserActionStatus.NOT_STARTED,
      lastUpdate: DateTime(2022, 12, 23, 0, 0, 0),
      creator: JeuneActionCreator(),
    ),
  ];
}
