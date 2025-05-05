import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_actions.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_state.dart';
import 'package:pass_emploi_app/models/onboarding.dart';
import 'package:pass_emploi_app/push/push_notification_manager.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/onboarding_repository.dart';
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
    } else if (action is OnboardingSaveAction) {
      final result = await _repository.get();
      final updatedOnboarding = _updateOnboarding(action, result);
      await _repository.save(updatedOnboarding);
      store.dispatch(OnboardingSuccessAction(updatedOnboarding));
    } else if (action is OnboardingPushNotificationPermissionRequestAction) {
      await _handleNotificationsPermissions(store);
    }
  }

  Future<void> _handleNotificationsPermissions(Store<AppState> store) async {
    await _manager.requestPermission();
    final onboardingState = store.state.onboardingState;
    if (onboardingState is OnboardingSuccessState) {
      final onboarding = onboardingState.onboarding;
      final updatedOnboarding = onboarding.copyWith(showNotificationsOnboarding: false);
      await _repository.save(updatedOnboarding);
      store.dispatch(OnboardingSuccessAction(updatedOnboarding));
    }
  }
}

Onboarding _updateOnboarding(OnboardingSaveAction action, Onboarding onboarding) {
  // TODO:
  throw UnimplementedError('Update onboarding logic not implemented');
  // return switch (action) {
  //   OnboardingAccueilSaveAction() => onboarding.copyWith(showAccueilOnboarding: false),
  // };
}
