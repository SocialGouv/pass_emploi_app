import 'package:pass_emploi_app/features/campagne_recrutement/campagne_recrutement_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/campagne_recrutement_repository.dart';
import 'package:redux/redux.dart';

class CampagneRecrutementMiddleware extends MiddlewareClass<AppState> {
  final CampagneRecrutementRepository _repository;

  CampagneRecrutementMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId == null) return;
    if (action is CampagneRecrutementRequestAction) {
      store.dispatch(CampagneRecrutementLoadingAction());
      final result = await _repository.shouldShowCampagneRecrutement();
      if (result != null) {
        store.dispatch(CampagneRecrutementSuccessAction(result));
      } else {
        store.dispatch(CampagneRecrutementFailureAction());
      }
    }
  }
}
