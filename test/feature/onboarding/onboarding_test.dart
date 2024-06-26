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
    final pushNotificationManager = MockPushNotificationManager();

    group("on bootstrap", () {
      sut.whenDispatchingAction(() => BootstrapAction());

      test('should succeed when request succeeds', () {
        when(() => repository.get()).thenAnswer((_) async => Onboarding());

        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.onboardingRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldSucceed(Onboarding())]);
      });
    });

    group("when requesting push notification permission", () {
      sut.whenDispatchingAction(() => OnboardingPushNotificationPermissionRequestAction());

      test('should wait for requested permission and update onboarding state', () {
        when(() => repository.get()).thenAnswer((_) async => Onboarding());
        when(() => repository.save(any())).thenAnswer((_) async {});
        when(() => pushNotificationManager.requestPermission()).thenAnswer((_) async {});

        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.onboardingRepository = repository, f.pushNotificationManager = pushNotificationManager});

        sut.thenExpectChangingStatesThroughOrder([_shouldSucceed(Onboarding(showAccueilOnboarding: false))]);
        verify(() => pushNotificationManager.requestPermission()).called(1);
      });
    });

    group('on save', () {
      group('OnboardingAccueilSaveAction', () {
        sut.whenDispatchingAction(() => OnboardingAccueilSaveAction());
        test('should save accuil onboarding', () {
          when(() => repository.get()).thenAnswer((_) async => Onboarding());
          when(() => repository.save(any())).thenAnswer((_) async {});

          sut.givenStore = givenState() //
              .loggedIn()
              .store((f) => {f.onboardingRepository = repository});

          sut.thenExpectChangingStatesThroughOrder([_shouldSucceed(Onboarding(showAccueilOnboarding: false))]);
        });
      });

      group('OnboardingMonSuiviSaveAction', () {
        sut.whenDispatchingAction(() => OnboardingMonSuiviSaveAction());
        test('should save mon suivi onboarding', () {
          when(() => repository.get()).thenAnswer((_) async => Onboarding());
          when(() => repository.save(any())).thenAnswer((_) async {});

          sut.givenStore = givenState() //
              .loggedIn()
              .store((f) => {f.onboardingRepository = repository});

          sut.thenExpectChangingStatesThroughOrder([_shouldSucceed(Onboarding(showMonSuiviOnboarding: false))]);
        });
      });

      group('OnboardingChatSaveAction', () {
        sut.whenDispatchingAction(() => OnboardingChatSaveAction());
        test('should save chat onboarding', () {
          when(() => repository.get()).thenAnswer((_) async => Onboarding());
          when(() => repository.save(any())).thenAnswer((_) async {});

          sut.givenStore = givenState() //
              .loggedIn()
              .store((f) => {f.onboardingRepository = repository});

          sut.thenExpectChangingStatesThroughOrder([_shouldSucceed(Onboarding(showChatOnboarding: false))]);
        });
      });

      group('OnboardingRechercheSaveAction', () {
        sut.whenDispatchingAction(() => OnboardingRechercheSaveAction());
        test('should save recherche onboarding', () {
          when(() => repository.get()).thenAnswer((_) async => Onboarding());
          when(() => repository.save(any())).thenAnswer((_) async {});

          sut.givenStore = givenState() //
              .loggedIn()
              .store((f) => {f.onboardingRepository = repository});

          sut.thenExpectChangingStatesThroughOrder([_shouldSucceed(Onboarding(showRechercheOnboarding: false))]);
        });
      });

      group('OnboardingEvenementsSaveAction', () {
        sut.whenDispatchingAction(() => OnboardingEvenementsSaveAction());
        test('should save evenements onboarding', () {
          when(() => repository.get()).thenAnswer((_) async => Onboarding());
          when(() => repository.save(any())).thenAnswer((_) async {});

          sut.givenStore = givenState() //
              .loggedIn()
              .store((f) => {f.onboardingRepository = repository});

          sut.thenExpectChangingStatesThroughOrder([_shouldSucceed(Onboarding(showEvenementsOnboarding: false))]);
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
