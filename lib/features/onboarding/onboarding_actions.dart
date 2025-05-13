import 'package:pass_emploi_app/models/onboarding.dart';

class OnboardingSuccessAction {
  final Onboarding onboarding;

  OnboardingSuccessAction(this.onboarding);
}

class OnboardingPushNotificationPermissionRequestAction {}

class ResetOnboardingShowcaseAction {}

class OnboardingHideAction {}

sealed class OnboardingStartedAction {}

class MessageOnboardingStartedAction extends OnboardingStartedAction {}

class ActionOnboardingStartedAction extends OnboardingStartedAction {}

class OffreOnboardingStartedAction extends OnboardingStartedAction {}

class EvenementOnboardingStartedAction extends OnboardingStartedAction {}

class OutilsOnboardingStartedAction extends OnboardingStartedAction {}

// sealed class OnboardingSaveAction {}

// class OnboardingAccueilSaveAction extends OnboardingSaveAction {}

// class MessageOnboardingSaveAction extends OnboardingSaveAction {}

// class ActionOnboardingSaveAction extends OnboardingSaveAction {}

// class OffreOnboardingSaveAction extends OnboardingSaveAction {}

// class EvenementOnboardingSaveAction extends OnboardingSaveAction {}

// class OutilsOnboardingSaveAction extends OnboardingSaveAction {}
