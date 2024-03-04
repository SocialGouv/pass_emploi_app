import 'package:pass_emploi_app/features/onboarding/onboarding_state.dart';

class OnboardingRequestAction {}

class OnboardingSuccessAction {
  final Onboarding result;

  OnboardingSuccessAction(this.result);
}

class OnboardingAccueilSaveAction {
  OnboardingAccueilSaveAction();
}
