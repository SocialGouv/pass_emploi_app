import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group("UserActionCreate", () {
    final sut = StoreSut();
    final repository = MockUserActionRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => UserActionCreateRequestAction(mockUserActionCreateRequest()));

      test("should load then succeed when request succeeds", () {
        when(() => repository.createUserAction('id', mockUserActionCreateRequest())).thenAnswer((_) async => 'created');

        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.userActionRepository = repository});
        sut.thenExpectChangingStatesThroughOrder([_shouldLoadState(), _shouldSucceedState()]);
      });

      test("should load then fail when request fails", () {
        when(() => repository.createUserAction('id', mockUserActionCreateRequest())).thenAnswer((_) async => null);

        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.userActionRepository = repository});
        sut.thenExpectChangingStatesThroughOrder([_shouldLoadState(), _shouldFailState()]);
      });
    });
  });
}

Matcher _shouldLoadState() => StateIs<UserActionCreateLoadingState>((state) => state.userActionCreateState);

Matcher _shouldFailState() => StateIs<UserActionCreateFailureState>((state) => state.userActionCreateState);

Matcher _shouldSucceedState() {
  return StateIs<UserActionCreateSuccessState>(
    (state) => state.userActionCreateState,
    (state) => expect(state.userActionCreatedId, 'created'),
  );
}
