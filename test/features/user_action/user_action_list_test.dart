import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/create/pending/user_action_create_pending_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_actions.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';

import '../../doubles/stubs.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  final sut = StoreSut();

  group("when creating user action", () {
    sut.whenDispatchingAction(() => UserActionListRequestAction());

    group("and request succeeds", () {
      test("should display loading and success", () {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.userActionRepository = PageActionRepositorySuccessStub()});
        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });
    });

    group("and request fails", () {
      test("should display loading and failure", () {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.userActionRepository = PageActionRepositoryFailureStub()});
        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });

  group("when user action have been created", () {
    sut.whenDispatchingAction(() => UserActionCreateSuccessAction('USER-ACTION-ID'));

    group("and request succeeds", () {
      test("should display loading and success", () {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.userActionRepository = PageActionRepositorySuccessStub()});
        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });
    });
  });

  group("when pending user actions have been created", () {
    sut.whenDispatchingAction(() => UserActionCreatePendingAction(0));

    group("and request succeeds", () {
      test("should display loading and success", () {
        sut.givenStore = givenState()
            .loggedInUser() //
            .withPendingUserActions(1)
            .store((f) => {f.userActionRepository = PageActionRepositorySuccessStub()});
        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<UserActionListLoadingState>((state) => state.userActionListState);

Matcher _shouldSucceed() {
  return StateIs<UserActionListSuccessState>(
    (state) => state.userActionListState,
    (state) => expect(state.userActions, isNotEmpty),
  );
}

Matcher _shouldFail() => StateIs<UserActionListFailureState>((state) => state.userActionListState);
