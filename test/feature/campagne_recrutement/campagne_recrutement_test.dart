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

      test('should load then succeed when request succeeds', () {
        when(() => repository.shouldShowCampagneRecrutement()).thenAnswer((_) async => true);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.campagneRecrutementRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fails', () {
        when(() => repository.shouldShowCampagneRecrutement()).thenAnswer((_) async => null);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.campagneRecrutementRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<CampagneRecrutementLoadingState>((state) => state.campagneRecrutementState);

Matcher _shouldFail() => StateIs<CampagneRecrutementFailureState>((state) => state.campagneRecrutementState);

Matcher _shouldSucceed() {
  return StateIs<CampagneRecrutementSuccessState>(
    (state) => state.campagneRecrutementState,
    (state) {
      expect(state.result, true);
    },
  );
}
