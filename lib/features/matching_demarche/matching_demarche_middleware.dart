import 'package:pass_emploi_app/features/matching_demarche/matching_demarche_actions.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_store_extension.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/matching_demarche_repository.dart';
import 'package:redux/redux.dart';

class MatchingDemarcheMiddleware extends MiddlewareClass<AppState> {
  final MatchingDemarcheRepository _repository;

  MatchingDemarcheMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is MatchingDemarcheRequestAction) {
      final demarche = store.getDemarcheOrNull(action.demarcheId);

      if (demarche != null) {
        store.dispatch(MatchingDemarcheLoadingAction());

        final result = await _repository.getMatchingDemarcheDuReferentiel(demarche);
        store.dispatch(MatchingDemarcheSuccessAction(result));
      } else {
        store.dispatch(MatchingDemarcheFailureAction());
      }
    }
  }
}
