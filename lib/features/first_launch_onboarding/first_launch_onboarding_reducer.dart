import 'package:pass_emploi_app/features/first_launch_onboarding/first_launch_onboarding_actions.dart';
import 'package:pass_emploi_app/features/first_launch_onboarding/first_launch_onboarding_state.dart';

FirstLaunchOnboardingState firstLaunchOnboardingReducer(FirstLaunchOnboardingState current, dynamic action) {
  if (action is FirstLaunchOnboardingSuccessAction) return FirstLaunchOnboardingSuccessState(action.showOnboarding);
  return current;
}
