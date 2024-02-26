import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/campagne_recrutement/campagne_recrutement_actions.dart';
import 'package:pass_emploi_app/features/campagne_recrutement/campagne_recrutement_state.dart';

import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('CampagneRecrutement', () {
    final sut = StoreSut();
    final repository = MockCampagneRecrutementRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => CampagneRecrutementRequestAction());

      test('should not display campagne recrutement on first launch', () {
        when(() => repository.isFirstLaunch()).thenAnswer((_) async => true);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.campagneRecrutementRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldSucceed(false)]);
      });

      test('should show campagne recrutement', () {
        when(() => repository.isFirstLaunch()).thenAnswer((_) async => false);
        when(() => repository.shouldShowCampagneRecrutement()).thenAnswer((_) async => true);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.campagneRecrutementRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldSucceed(true)]);
      });
    });

    group('when dismiss', () {
      sut.whenDispatchingAction(() => CampagneRecrutementDismissAction());

      test('should dismiss campagne recrutement', () {
        when(() => repository.dismissCampagneRecrutement()).thenAnswer((_) async => true);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.campagneRecrutementRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldSucceed(false)]);
      });
    });
  });
}

Matcher _shouldSucceed(bool value) {
  return StateIs<CampagneRecrutementSuccessState>(
    (state) => state.campagneRecrutementState,
    (state) {
      expect(state.result, value);
    },
  );
}
