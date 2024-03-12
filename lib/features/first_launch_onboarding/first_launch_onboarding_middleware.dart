import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/first_launch_onboarding/first_launch_onboarding_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/first_launch_onboarding_repository.dart';
import 'package:redux/redux.dart';

class FirstLaunchOnboardingMiddleware extends MiddlewareClass<AppState> {
  final FirstLaunchOnboardingRepository _repository;

  FirstLaunchOnboardingMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is BootstrapAction) {
      final showOnboarding = await _repository.get();
      store.dispatch(FirstLaunchOnboardingSuccessAction(showOnboarding));
    }
  }
}
