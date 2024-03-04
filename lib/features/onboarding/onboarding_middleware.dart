import 'package:pass_emploi_app/features/onboarding/onboarding_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/onboarding_repository.dart';
import 'package:redux/redux.dart';

class OnboardingMiddleware extends MiddlewareClass<AppState> {
  final OnboardingRepository _repository;

  OnboardingMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is OnboardingRequestAction) {
      final result = await _repository.get();
      store.dispatch(OnboardingSuccessAction(result));
    } else if (action is OnboardingAccueilSaveAction) {
      // TODO: test me
      final result = await _repository.get();
      final updatedOnbaording = result.copyWith(showAccueilOnboarding: false);
      await _repository.save(updatedOnbaording);
      store.dispatch(OnboardingSuccessAction(updatedOnbaording));
    }
  }
}
