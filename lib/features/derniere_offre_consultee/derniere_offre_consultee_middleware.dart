import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/derniere_offre_consultee/derniere_offre_consultee_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/derniere_offre_consultee_repository.dart';
import 'package:redux/redux.dart';

class DerniereOffreConsulteeMiddleware extends MiddlewareClass<AppState> {
  final DerniereOffreConsulteeRepository _repository;

  DerniereOffreConsulteeMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is BootstrapAction) {
      final offre = await _repository.get();
      if (offre != null) {
        store.dispatch(DerniereOffreConsulteeUpdateAction(offre));
      }
    }

    if (action is DerniereOffreConsulteeWriteAction) {
      final offre = action.offre;
      await _repository.set(offre);
      store.dispatch(DerniereOffreConsulteeUpdateAction(offre));
    }
  }
}
