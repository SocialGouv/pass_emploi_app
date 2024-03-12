import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/first_launch_onboarding/first_launch_onboarding_state.dart';

import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('FirstLaunchOnboarding', () {
    final sut = StoreSut();
    final repository = MockFirstLaunchOnboardingRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => BootstrapAction());

      test('should load then succeed when request succeeds', () {
        when(() => repository.get()).thenAnswer((_) async => true);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.firstLaunchOnboardingRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldSucceed()]);
      });
    });
  });
}

Matcher _shouldSucceed() {
  return StateIs<FirstLaunchOnboardingSuccessState>(
    (state) => state.firstLaunchOnboardingState,
    (state) {
      expect(state.showOnboarding, true);
    },
  );
}
