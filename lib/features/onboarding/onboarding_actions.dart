import 'package:pass_emploi_app/models/onboarding.dart';

class OnboardingSuccessAction {
  final Onboarding result;

  OnboardingSuccessAction(this.result);
}

class OnboardingPushNotificationPermissionRequestAction {}

sealed class OnboardingSaveAction {}

class OnboardingAccueilSaveAction extends OnboardingSaveAction {}
