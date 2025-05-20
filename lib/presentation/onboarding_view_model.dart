import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_actions.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/models/onboarding.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class OnboardingViewModel extends Equatable {
  final int completedSteps;
  final int totalSteps;

  final bool messageCompleted;
  final bool withActionStep;
  final bool actionCompleted;
  final bool offreCompleted;
  final bool evenementCompleted;
  final bool outilsCompleted;

  final String actionStepLabel;

  final void Function() onMessageOnboarding;
  final void Function() onActionOnboarding;
  final void Function() onOffreOnboarding;
  final void Function() onEvenementOnboarding;
  final void Function() onOutilsOnboarding;
  final void Function() onSkipOnboarding;

  const OnboardingViewModel({
    required this.completedSteps,
    required this.totalSteps,
    required this.messageCompleted,
    required this.withActionStep,
    required this.actionCompleted,
    required this.offreCompleted,
    required this.evenementCompleted,
    required this.outilsCompleted,
    required this.actionStepLabel,
    required this.onMessageOnboarding,
    required this.onActionOnboarding,
    required this.onOffreOnboarding,
    required this.onEvenementOnboarding,
    required this.onOutilsOnboarding,
    required this.onSkipOnboarding,
  });

  factory OnboardingViewModel.create(Store<AppState> store) {
    final onboardingState = store.state.onboardingState;

    if (onboardingState.onboarding == null) {
      return OnboardingViewModel.empty();
    }

    final onboarding = onboardingState.onboarding!;

    return OnboardingViewModel(
      completedSteps: onboarding.completedSteps(store.state.accompagnement()),
      totalSteps: onboarding.totalSteps(store.state.accompagnement()),
      withActionStep: store.state.accompagnement() != Accompagnement.avenirPro,
      messageCompleted: onboarding.messageCompleted,
      actionCompleted: onboarding.actionCompleted,
      offreCompleted: onboarding.offreCompleted,
      evenementCompleted: onboarding.evenementCompleted,
      outilsCompleted: onboarding.outilsCompleted,
      actionStepLabel: _actionStepLabel(store),
      onMessageOnboarding: () {
        store.dispatch(HandleDeepLinkAction(NouveauMessageDeepLink(), DeepLinkOrigin.inAppNavigation));
        store.dispatch(MessageOnboardingStartedAction());
      },
      onActionOnboarding: () {
        store.dispatch(HandleDeepLinkAction(MonSuiviDeepLink(), DeepLinkOrigin.inAppNavigation));
        store.dispatch(ActionOnboardingStartedAction());
      },
      onOffreOnboarding: () {
        store.dispatch(HandleDeepLinkAction(RechercheDeepLink(), DeepLinkOrigin.inAppNavigation));
        store.dispatch(OffreOnboardingStartedAction());
      },
      onEvenementOnboarding: () {
        store.dispatch(HandleDeepLinkAction(EventSearchDeepLink(), DeepLinkOrigin.inAppNavigation));
        store.dispatch(EvenementOnboardingStartedAction());
      },
      onOutilsOnboarding: () {
        store.dispatch(HandleDeepLinkAction(OutilsDeepLink(), DeepLinkOrigin.inAppNavigation));
        store.dispatch(OutilsOnboardingStartedAction());
      },
      onSkipOnboarding: () {
        store.dispatch(OnboardingHideAction());
      },
    );
  }

  factory OnboardingViewModel.empty() {
    return OnboardingViewModel(
      completedSteps: 0,
      totalSteps: 0,
      messageCompleted: false,
      withActionStep: false,
      actionCompleted: false,
      offreCompleted: false,
      evenementCompleted: false,
      outilsCompleted: false,
      actionStepLabel: Strings.actionOnboardingSection,
      onMessageOnboarding: () {},
      onActionOnboarding: () {},
      onOffreOnboarding: () {},
      onEvenementOnboarding: () {},
      onOutilsOnboarding: () {},
      onSkipOnboarding: () {},
    );
  }

  @override
  List<Object?> get props => [
        completedSteps,
        totalSteps,
        messageCompleted,
        withActionStep,
        actionCompleted,
        offreCompleted,
        evenementCompleted,
        outilsCompleted,
        actionStepLabel,
      ];
}

String _actionStepLabel(Store<AppState> store) {
  return store.state.isMiloLoginMode() ? Strings.actionOnboardingSection : Strings.demarcheOnboardingSection;
}
