import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_actions.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_state.dart';
import 'package:pass_emploi_app/models/onboarding.dart';

import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  setUpAll(() => registerFallbackValue(Onboarding()));

  group('Onboarding', () {
    final sut = StoreSut();
    final repository = MockOnboardingRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => BootstrapAction());

      test('should succeed when request succeeds', () {
        when(() => repository.get()).thenAnswer((_) async => Onboarding());

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.onboardingRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldSucceed(Onboarding())]);
      });
    });

    group('on save', () {
      group('OnboardingAccueilSaveAction', () {
        sut.whenDispatchingAction(() => OnboardingAccueilSaveAction());
        test('should save accuil onboarding', () {
          when(() => repository.get()).thenAnswer((_) async => Onboarding());
          when(() => repository.save(any())).thenAnswer((_) async {});

          sut.givenStore = givenState() //
              .loggedInUser()
              .store((f) => {f.onboardingRepository = repository});

          sut.thenExpectChangingStatesThroughOrder(
              [_shouldSucceed(Onboarding().copyWith(showAccueilOnboarding: false))]);
        });
      });

      group('OnboardingMonSuiviSaveAction', () {
        sut.whenDispatchingAction(() => OnboardingMonSuiviSaveAction());
        test('should save mon suivi onboarding', () {
          when(() => repository.get()).thenAnswer((_) async => Onboarding());
          when(() => repository.save(any())).thenAnswer((_) async {});

          sut.givenStore = givenState() //
              .loggedInUser()
              .store((f) => {f.onboardingRepository = repository});

          sut.thenExpectChangingStatesThroughOrder(
              [_shouldSucceed(Onboarding().copyWith(showMonSuiviOnboarding: false))]);
        });
      });

      group('OnboardingChatSaveAction', () {
        sut.whenDispatchingAction(() => OnboardingChatSaveAction());
        test('should save chat onboarding', () {
          when(() => repository.get()).thenAnswer((_) async => Onboarding());
          when(() => repository.save(any())).thenAnswer((_) async {});

          sut.givenStore = givenState() //
              .loggedInUser()
              .store((f) => {f.onboardingRepository = repository});

          sut.thenExpectChangingStatesThroughOrder([_shouldSucceed(Onboarding().copyWith(showChatOnboarding: false))]);
        });
      });

      group('OnboardingRechercheSaveAction', () {
        sut.whenDispatchingAction(() => OnboardingRechercheSaveAction());
        test('should save recherche onboarding', () {
          when(() => repository.get()).thenAnswer((_) async => Onboarding());
          when(() => repository.save(any())).thenAnswer((_) async {});

          sut.givenStore = givenState() //
              .loggedInUser()
              .store((f) => {f.onboardingRepository = repository});

          sut.thenExpectChangingStatesThroughOrder(
              [_shouldSucceed(Onboarding().copyWith(showRechercheOnboarding: false))]);
        });
      });

      group('OnboardingEvenementsSaveAction', () {
        sut.whenDispatchingAction(() => OnboardingEvenementsSaveAction());
        test('should save evenements onboarding', () {
          when(() => repository.get()).thenAnswer((_) async => Onboarding());
          when(() => repository.save(any())).thenAnswer((_) async {});

          sut.givenStore = givenState() //
              .loggedInUser()
              .store((f) => {f.onboardingRepository = repository});

          sut.thenExpectChangingStatesThroughOrder(
              [_shouldSucceed(Onboarding().copyWith(showEvenementsOnboarding: false))]);
        });
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
