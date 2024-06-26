import 'package:pass_emploi_app/features/campagne_recrutement/campagne_recrutement_actions.dart';
import 'package:pass_emploi_app/features/feature_flip/feature_flip_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/campagne_recrutement_repository.dart';
import 'package:redux/redux.dart';

class CampagneRecrutementMiddleware extends MiddlewareClass<AppState> {
  final CampagneRecrutementRepository _repository;

  CampagneRecrutementMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is CampagneRecrutementRequestAction) {
      final isFirstLaunch = await _repository.isFirstLaunch();
      if (isFirstLaunch) {
        await _repository.setCampagneRecrutementInitialRead();
        store.dispatch(FeatureFlipCampagneRecrutementAction(true));
      } else {
        final shouldShowCampagne = await _repository.shouldShowCampagneRecrutement();
        store.dispatch(FeatureFlipCampagneRecrutementAction(shouldShowCampagne));
      }
    } else if (action is CampagneRecrutementDismissAction) {
      await _repository.dismissCampagneRecrutement();
      store.dispatch(FeatureFlipCampagneRecrutementAction(false));
    }
  }
}
