import 'package:pass_emploi_app/features/onboarding/onboarding_actions.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_state.dart';

OnboardingState onboardingReducer(OnboardingState current, dynamic action) {
  if (action is OnboardingSuccessAction) return OnboardingSuccessState(action.result);
  return current;
}
