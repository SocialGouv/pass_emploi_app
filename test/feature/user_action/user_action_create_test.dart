import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/models/user_action.dart';

import '../../doubles/stubs.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  final sut = StoreSut();

  group("when creating user action", () {
    sut.when(() => UserActionCreateRequestAction(_request()));

    group("when request succeed", () {
      test("should display loading and success", () {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.pageActionRepository = PageActionRepositorySuccessStub()});
        sut.thenExpectChangingStatesThroughOrder([_shouldLoadState(), _shouldSucceedState()]);
      });

      test("should update list", () {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.pageActionRepository = PageActionRepositorySuccessStub()});
        sut.thenExpectChangingStatesThroughOrder([_shouldLoadList(), _shouldUpdateList()]);
      });
    });

    group("when request fail", () {
      test("should display loading and failure", () {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.pageActionRepository = PageActionRepositoryFailureStub()});
        sut.thenExpectChangingStatesThroughOrder([_shouldLoadState(), _shouldFailState()]);
      });
    });
  });
}

Matcher _shouldLoadState() => StateIs<UserActionCreateLoadingState>((state) => state.userActionCreateState);

Matcher _shouldSucceedState() => StateIs<UserActionCreateSuccessState>((state) => state.userActionCreateState);

Matcher _shouldFailState() => StateIs<UserActionCreateFailureState>((state) => state.userActionCreateState);

Matcher _shouldLoadList() => StateIs<UserActionListLoadingState>((state) => state.userActionListState);

Matcher _shouldUpdateList() {
  return StateIs<UserActionListSuccessState>(
    (state) => state.userActionListState,
    (state) => expect(state.userActions, isNotEmpty),
  );
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
