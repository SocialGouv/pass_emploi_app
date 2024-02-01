import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('UserActionDelete', () {
    final sut = StoreSut();
    final repository = MockUserActionRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => UserActionDeleteRequestAction('id'));

      test('should load then succeed when request succeeds', () {
        when(() => repository.deleteUserAction('id')).thenAnswer((_) async => true);

        sut.givenStore = givenState() //
            .loggedInMiloUser() //
            .withActions([mockUserAction(id: 'id')]) //
            .store((f) => {f.userActionRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fails', () {
        when(() => repository.deleteUserAction('id')).thenAnswer((_) async => false);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.userActionRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });

      test('should update mon suivi state when request succeeds', () {
        when(() => repository.deleteUserAction('id')).thenAnswer((_) async => true);

        sut.givenStore = givenState() //
            .loggedInMiloUser() //
            .withActions([mockNotStartedAction(actionId: 'id')]) //
            .store((f) => {f.userActionRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([
          _currentMonSuivi(), // state change because of UserActionDeleteRequestAction
          _currentMonSuivi(), // state change because of UserActionDeleteLoadingAction
          _shouldUpdateMonSuivi(), // state change because of UserActionDeleteSuccessAction
        ]);
      });

      test('should not update mon suivi state when request fails', () {
        when(() => repository.deleteUserAction('id')).thenAnswer((_) async => false);

        sut.givenStore = givenState() //
            .loggedInMiloUser() //
            .withActions([mockNotStartedAction(actionId: 'id')]) //
            .store((f) => {f.userActionRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([
          _currentMonSuivi(), // state change because of UserActionDeleteRequestAction
          _currentMonSuivi(), // state change because of UserActionDeleteLoadingAction
          _shouldNotUpdateMonSuivi(), // state change because of UserActionDeleteFailureAction
        ]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<UserActionDeleteLoadingState>((state) => state.userActionDeleteState);

Matcher _shouldFail() => StateIs<UserActionDeleteFailureState>((state) => state.userActionDeleteState);

Matcher _shouldSucceed() => StateIs<UserActionDeleteSuccessState>((state) => state.userActionDeleteState);

Matcher _currentMonSuivi() => StateIs<MonSuiviSuccessState>((state) => state.monSuiviState);

Matcher _shouldUpdateMonSuivi() {
  return StateIs<MonSuiviSuccessState>(
    (state) => state.monSuiviState,
    (state) => expect(state.monSuivi.actions, isEmpty),
  );
}

Matcher _shouldNotUpdateMonSuivi() {
  return StateIs<MonSuiviSuccessState>(
    (state) => state.monSuiviState,
    (state) => expect(state.monSuivi.actions, isNotEmpty),
  );
}
