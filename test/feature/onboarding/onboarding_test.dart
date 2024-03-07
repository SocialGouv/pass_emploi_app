import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_actions.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_state.dart';

import '../../doubles/dummies.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  setUpAll(() => registerFallbackValue(dummyOnboarding));

  group('Onboarding', () {
    final sut = StoreSut();
    final repository = MockOnboardingRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => BootstrapAction());

      test('should succeed when request succeeds', () {
        when(() => repository.get()).thenAnswer((_) async => dummyOnboarding);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.onboardingRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldSucceed(dummyOnboarding)]);
      });
    });

    group('on save', () {
      test('should save accuil onboarding', () {
        sut.whenDispatchingAction(() => OnboardingAccueilSaveAction());
        when(() => repository.get()).thenAnswer((_) async => dummyOnboarding);
        when(() => repository.save(any())).thenAnswer((_) async {});

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.onboardingRepository = repository});

        sut.thenExpectChangingStatesThroughOrder(
            [_shouldSucceed(dummyOnboarding.copyWith(showAccueilOnboarding: false))]);
      });
      test('should save mon suivi onboarding', () {
        sut.whenDispatchingAction(() => OnboardingMonSuiviSaveAction());
        when(() => repository.get()).thenAnswer((_) async => dummyOnboarding);
        when(() => repository.save(any())).thenAnswer((_) async {});

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.onboardingRepository = repository});

        sut.thenExpectChangingStatesThroughOrder(
            [_shouldSucceed(dummyOnboarding.copyWith(showMonSuiviOnboarding: false))]);
      });
      test('should save chat onboarding', () {
        sut.whenDispatchingAction(() => OnboardingChatSaveAction());
        when(() => repository.get()).thenAnswer((_) async => dummyOnboarding);
        when(() => repository.save(any())).thenAnswer((_) async {});

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.onboardingRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldSucceed(dummyOnboarding.copyWith(showChatOnboarding: false))]);
      });
      test('should save recherche onboarding', () {
        sut.whenDispatchingAction(() => OnboardingRechercheSaveAction());
        when(() => repository.get()).thenAnswer((_) async => dummyOnboarding);
        when(() => repository.save(any())).thenAnswer((_) async {});

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.onboardingRepository = repository});

        sut.thenExpectChangingStatesThroughOrder(
            [_shouldSucceed(dummyOnboarding.copyWith(showRechercheOnboarding: false))]);
      });
      test('should save evenements onboarding', () {
        sut.whenDispatchingAction(() => OnboardingEvenementsSaveAction());
        when(() => repository.get()).thenAnswer((_) async => dummyOnboarding);
        when(() => repository.save(any())).thenAnswer((_) async {});

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.onboardingRepository = repository});

        sut.thenExpectChangingStatesThroughOrder(
            [_shouldSucceed(dummyOnboarding.copyWith(showEvenementsOnboarding: false))]);
      });
    });
  });
}

Matcher _shouldSucceed(Onboarding onboarding) {
  return StateIs<OnboardingSuccessState>(
    (state) => state.onboardingState,
    (state) {
      expect(state.result, onboarding);
    },
  );
}
