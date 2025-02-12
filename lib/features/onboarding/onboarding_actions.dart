import 'package:pass_emploi_app/models/onboarding.dart';

class OnboardingSuccessAction {
  final Onboarding result;

  OnboardingSuccessAction(this.result);
}

class OnboardingPushNotificationPermissionRequestAction {}

sealed class OnboardingSaveAction {}

class OnboardingAccueilSaveAction extends OnboardingSaveAction {}

class OnboardingMonSuiviSaveAction extends OnboardingSaveAction {}

class OnboardingChatSaveAction extends OnboardingSaveAction {}

class OnboardingRechercheSaveAction extends OnboardingSaveAction {}

class OnboardingEvenementsSaveAction extends OnboardingSaveAction {}

class OnboardingOffreEnregistreeSaveAction extends OnboardingSaveAction {}
