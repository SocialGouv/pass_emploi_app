import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_state.dart';
import 'package:pass_emploi_app/presentation/events/event_tab_page_view_model.dart';

import '../../dsl/app_state_dsl.dart';

void main() {
  group('onboarding', () {
    test('should display onboarding', () {
      // Given
      final store = givenState()
          .copyWith(onboardingState: OnboardingSuccessState(Onboarding(showEvenementsOnboarding: true)))
          .store();

      // When
      final viewModel = EventsTabPageViewModel.create(store);

      // Then
      expect(viewModel.shouldShowOnboarding, isTrue);
    });

    test('should not display onboarding', () {
      // Given
      final store = givenState()
          .copyWith(onboardingState: OnboardingSuccessState(Onboarding(showEvenementsOnboarding: false)))
          .store();

      // When
      final viewModel = EventsTabPageViewModel.create(store);

      // Then
      expect(viewModel.shouldShowOnboarding, isFalse);
    });
  });
}
