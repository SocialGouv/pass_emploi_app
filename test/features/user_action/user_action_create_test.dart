import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  final sut = StoreSut();

  group("when creating user action", () {
    sut.whenDispatchingAction(() => UserActionCreateRequestAction(dummyUserActionCreateRequest()));

    group("when request succeeds", () {
      test("should display loading and success", () {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.userActionRepository = UserActionRepositorySuccessStub()});
        sut.thenExpectChangingStatesThroughOrder([_shouldLoadState(), _shouldSucceedState()]);
      });
    });

    group("when request fails", () {
      test("should display loading and failure", () {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.userActionRepository = UserActionRepositoryFailureStub()});
        sut.thenExpectChangingStatesThroughOrder([_shouldLoadState(), _shouldFailState()]);
      });
    });
  });
}

Matcher _shouldLoadState() => StateIs<UserActionCreateLoadingState>((state) => state.userActionCreateState);

Matcher _shouldSucceedState() {
  return StateIs<UserActionCreateSuccessState>(
    (state) => state.userActionCreateState,
    (state) => expect(state.userActionCreatedId, 'USER-ACTION-ID'),
  );
}

Matcher _shouldFailState() => StateIs<UserActionCreateFailureState>((state) => state.userActionCreateState);
