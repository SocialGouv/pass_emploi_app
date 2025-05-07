import 'package:pass_emploi_app/features/onboarding/onboarding_actions.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_state.dart';

OnboardingState onboardingReducer(OnboardingState current, dynamic action) {
  if (action is OnboardingSuccessAction) return current.copyWith(onboarding: action.onboarding);
  if (action is OnboardingStartedAction) {
    return switch (action) {
      MessageOnboardingStartedAction() => current.copyWith(showMessageOnboarding: true),
      ActionOnboardingStartedAction() => current.copyWith(showActionOnboarding: true),
      OffreOnboardingStartedAction() => current.copyWith(showOffreOnboarding: true),
      EvenementOnboardingStartedAction() => current.copyWith(showEvenementOnboarding: true),
      OutilsOnboardingStartedAction() => current.copyWith(showOutilsOnboarding: true)
    };
  }
  return current;
}
