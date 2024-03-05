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
      sut.whenDispatchingAction(() => OnboardingAccueilSaveAction());

      test('should succeed when save succeeds', () {
        when(() => repository.get()).thenAnswer((_) async => dummyOnboarding);
        when(() => repository.save(any())).thenAnswer((_) async {});

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.onboardingRepository = repository});

        sut.thenExpectChangingStatesThroughOrder(
            [_shouldSucceed(dummyOnboarding.copyWith(showAccueilOnboarding: false))]);
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
