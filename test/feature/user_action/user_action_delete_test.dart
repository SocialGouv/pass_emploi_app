import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

import '../../doubles/stubs.dart';
import '../../utils/test_setup.dart';

void main() {
  test("delete user action when repo succeeds should display loading and then delete user action", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.userActionRepository = UserActionRepositorySuccessStub();
    final store = testStoreFactory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(userActionListState: UserActionListSuccessState(_userActions())),
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
  });

  test("delete user action when repo fails should display loading and keep user action", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.userActionRepository = UserActionRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(userActionListState: UserActionListSuccessState(_userActions())),
    );
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
