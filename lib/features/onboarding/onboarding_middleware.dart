import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_actions.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/models/onboarding.dart';
import 'package:pass_emploi_app/push/push_notification_manager.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/onboarding_repository.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:redux/redux.dart';

class OnboardingMiddleware extends MiddlewareClass<AppState> {
  final OnboardingRepository _repository;
  final PushNotificationManager _manager;

  OnboardingMiddleware(this._repository, this._manager);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is BootstrapAction) {
      final result = await _repository.get();
      store.dispatch(OnboardingSuccessAction(result));
    } else if (action is OnboardingPushNotificationPermissionRequestAction) {
      await _handleNotificationsPermissions(store);
    } else if (action is SendMessageAction) {
      _updateOnboarding(store, (onboarding) => onboarding?.copyWith(messageCompleted: true));
    } else if (action is UserActionCreateSuccessAction || action is CreateDemarcheSuccessAction) {
      _updateOnboarding(store, (onboarding) => onboarding?.copyWith(actionCompleted: true));
    } else if (action is RechercheRequestAction) {
      if (action is RechercheRequestAction<EvenementEmploiCriteresRecherche, EvenementEmploiFiltresRecherche>) {
        _updateOnboarding(store, (onboarding) => onboarding?.copyWith(evenementCompleted: true));
      } else {
        _updateOnboarding(store, (onboarding) => onboarding?.copyWith(offreCompleted: true));
      }
    } else if (action is OutilsOnboardingStartedAction) {
      // delayed to let user see the onboarding
      Future.delayed(const Duration(seconds: 1), () {
        _updateOnboarding(store, (onboarding) => onboarding?.copyWith(outilsCompleted: true));
      });
    } else if (action is OnboardingHideAction) {
      _updateOnboarding(store, (onboarding) => onboarding?.copyWith(showOnboarding: false));
    }
  }

  Future<void> _handleNotificationsPermissions(Store<AppState> store) async {
    await _manager.requestPermission();
    final onboardingState = store.state.onboardingState;
    if (onboardingState.onboarding != null) {
      final onboarding = onboardingState.onboarding;
      final updatedOnboarding = onboarding!.copyWith(showNotificationsOnboarding: false);
      await _repository.save(updatedOnboarding);
      store.dispatch(OnboardingSuccessAction(updatedOnboarding));
    }
  }

  Future<void> _updateOnboarding(Store<AppState> store, Onboarding? Function(Onboarding?) update) async {
    final onboardingState = store.state.onboardingState;
    final onboarding = onboardingState.onboarding;
    final updatedOnboarding = update(onboarding);
    if (updatedOnboarding != null) {
      await _repository.save(updatedOnboarding);
      store.dispatch(OnboardingSuccessAction(updatedOnboarding));
      if (updatedOnboarding.isCompleted(store.state.accompagnement())) {
        PassEmploiMatomoTracker.instance.trackEvent(
          eventCategory: AnalyticsEventNames.onboardingCategory,
          action: AnalyticsEventNames.onboardingCompletedOnboardingAction,
        );
        await _repository.save(updatedOnboarding.copyWith(showOnboarding: false));
      }
    }
  }
}
