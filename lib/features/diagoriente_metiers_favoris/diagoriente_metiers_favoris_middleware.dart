import 'package:pass_emploi_app/features/diagoriente_metiers_favoris/diagoriente_metiers_favoris_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/diagoriente_metiers_favoris_repository.dart';
import 'package:redux/redux.dart';

class DiagorienteMetiersFavorisMiddleware extends MiddlewareClass<AppState> {
  final DiagorienteMetiersFavorisRepository _repository;

  DiagorienteMetiersFavorisMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId != null && action is DiagorienteMetiersFavorisRequestAction) {
      store.dispatch(DiagorienteMetiersFavorisLoadingAction());
      final aDesMetiersFavoris = await _repository.get(userId);
      if (aDesMetiersFavoris != null) {
        store.dispatch(DiagorienteMetiersFavorisSuccessAction(aDesMetiersFavoris));
      } else {
        store.dispatch(DiagorienteMetiersFavorisFailureAction());
      }
    }
  }
}
