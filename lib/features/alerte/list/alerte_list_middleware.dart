import 'package:pass_emploi_app/features/alerte/list/alerte_list_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/alerte/get_alerte_repository.dart';
import 'package:redux/redux.dart';

class AlerteListMiddleware extends MiddlewareClass<AppState> {
  final GetAlerteRepository _repository;

  AlerteListMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final userId = store.state.userId();
    if (userId == null) return;

    if (action is AlerteListRequestAction) {
      await _fetchAlerte(store, userId);
    } else if (action is AccepterSuggestionRechercheSuccessAction) {
      await _fetchAlerte(store, userId);
    }
  }

  Future<void> _fetchAlerte(Store<AppState> store, String userId) async {
    store.dispatch(AlerteListLoadingAction());
    final alertes = await _repository.getAlerte(userId);
    store.dispatch(
      alertes != null ? AlerteListSuccessAction(alertes) : AlerteListFailureAction(),
    );
  }
}
