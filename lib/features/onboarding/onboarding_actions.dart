import 'package:pass_emploi_app/features/onboarding/onboarding_state.dart';

class OnboardingSuccessAction {
  final Onboarding result;

  OnboardingSuccessAction(this.result);
}

sealed class OnboardingSaveAction {}

class OnboardingAccueilSaveAction extends OnboardingSaveAction {}

class OnboardingMonSuiviSaveAction extends OnboardingSaveAction {}

class OnboardingChatSaveAction extends OnboardingSaveAction {}

class OnboardingRechercheSaveAction extends OnboardingSaveAction {}

class OnboardingEvenementsSaveAction extends OnboardingSaveAction {}
