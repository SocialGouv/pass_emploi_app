import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/auto_inscription/auto_inscription_actions.dart';
import 'package:pass_emploi_app/features/comptage_des_heures/comptage_des_heures_actions.dart';
import 'package:pass_emploi_app/features/comptage_des_heures/comptage_des_heures_state.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('ComptageDesHeures', () {
    final sut = StoreSut();
    final repository = MockComptageDesHeuresRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => ComptageDesHeuresRequestAction());

      test('should load then succeed when request succeeds', () {
        when(() => repository.get(userId: any(named: "userId"))).thenAnswer((_) async => mockComptageDesHeures());

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.comptageDesHeuresRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldSucceed()]);
      });

      test('should load then fail when request fails', () {
        when(() => repository.get(userId: any(named: "userId"))).thenAnswer((_) async => null);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.comptageDesHeuresRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldFail()]);
      });

      test('should not emit new state if comptage des heures is the same', () {
        when(() => repository.get(userId: any(named: "userId"))).thenAnswer((_) async => mockComptageDesHeures());

        sut.givenStore = givenState() //
            .loggedInUser()
            .withComptageDesHeuresSuccess(comptageDesHeures: mockComptageDesHeures())
            .store((f) => {f.comptageDesHeuresRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([]);
      });
    });

    group("when creating action", () {
      sut.whenDispatchingAction(() => UserActionCreateSuccessAction('any'));

      test('should increment heures en cours de calcul when user action create success', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .withComptageDesHeuresSuccess(comptageDesHeures: mockComptageDesHeures())
            .store((f) => {f.comptageDesHeuresRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldIncrementHeuresEnCoursDeCalcul()]);
      });
    });

    group("when auto-inscription success", () {
      sut.whenDispatchingAction(() => AutoInscriptionSuccessAction());

      test('should increment heures en cours de calcul when user action create success', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .withComptageDesHeuresSuccess(comptageDesHeures: mockComptageDesHeures())
            .store((f) => {f.comptageDesHeuresRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldIncrementHeuresEnCoursDeCalcul()]);
      });
    });
  });
}

Matcher _shouldFail() => StateIs<ComptageDesHeuresFailureState>((state) => state.comptageDesHeuresState);

Matcher _shouldSucceed() {
  return StateIs<ComptageDesHeuresSuccessState>(
    (state) => state.comptageDesHeuresState,
    (state) {
      expect(
        state.comptageDesHeures,
        mockComptageDesHeures(),
      );
    },
  );
}

Matcher _shouldIncrementHeuresEnCoursDeCalcul() {
  return StateIs<ComptageDesHeuresSuccessState>(
    (state) => state.comptageDesHeuresState,
    (state) {
      expect(state.heuresEnCoursDeCalcul, 1);
    },
  );
}
