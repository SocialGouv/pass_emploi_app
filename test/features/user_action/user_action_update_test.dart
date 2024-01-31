import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/user_action.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('UserActionUpdate', () {
    final sut = StoreSut();
    final repository = MockUserActionRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(
        () => UserActionUpdateRequestAction(actionId: 'id', request: mockUserActionUpdateRequest()),
      );

      test('should load then succeed when request succeeds', () {
        when(() => repository.updateUserAction('id', mockUserActionUpdateRequest())).thenAnswer((_) async => true);

        sut.givenStore = givenState() //
            .loggedInMiloUser() //
            .withActions([mockUserAction(id: 'id')]) //
            .store((f) => {f.userActionRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fails', () {
        when(() => repository.updateUserAction('id', mockUserActionUpdateRequest())).thenAnswer((_) async => false);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.userActionRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });

      test('should update mon suivi state when request succeeds', () {
        when(() => repository.updateUserAction('id', mockUserActionUpdateRequest())).thenAnswer((_) async => true);

        sut.givenStore = givenState() //
            .loggedInMiloUser() //
            .withActions([mockNotStartedAction(actionId: 'id')]) //
            .store((f) => {f.userActionRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([
          _currentMonSuivi(), // state change because of UserActionUpdateRequestAction
          _currentMonSuivi(), // state change because of UserActionUpdateLoadingAction
          _shouldUpdateMonSuivi(), // state change because of UserActionUpdateSuccessAction
        ]);
      });

      test('should not update mon suivi state when request fails', () {
        when(() => repository.updateUserAction('id', mockUserActionUpdateRequest())).thenAnswer((_) async => false);

        sut.givenStore = givenState() //
            .loggedInMiloUser() //
            .withActions([mockNotStartedAction(actionId: 'id')]) //
            .store((f) => {f.userActionRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([
          _currentMonSuivi(), // state change because of UserActionUpdateRequestAction
          _currentMonSuivi(), // state change because of UserActionUpdateLoadingAction
          _shouldNotUpdateMonSuivi(), // state change because of UserActionUpdateFailureAction
        ]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<UserActionUpdateLoadingState>((state) => state.userActionUpdateState);

Matcher _shouldFail() => StateIs<UserActionUpdateFailureState>((state) => state.userActionUpdateState);

Matcher _shouldSucceed() => StateIs<UserActionUpdateSuccessState>((state) => state.userActionUpdateState);

Matcher _currentMonSuivi() => StateIs<MonSuiviSuccessState>((state) => state.monSuiviState);

Matcher _shouldUpdateMonSuivi() {
  return StateIs<MonSuiviSuccessState>(
    (state) => state.monSuiviState,
    (state) => expect(state.monSuivi.actions.first.status, UserActionStatus.DONE),
  );
}

Matcher _shouldNotUpdateMonSuivi() {
  return StateIs<MonSuiviSuccessState>(
    (state) => state.monSuiviState,
    (state) => expect(state.monSuivi.actions.first.status, UserActionStatus.NOT_STARTED),
  );
}
