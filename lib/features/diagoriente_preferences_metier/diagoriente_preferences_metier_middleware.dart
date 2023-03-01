import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/diagoriente_urls_repository.dart';
import 'package:redux/redux.dart';

class DiagorientePreferencesMetierMiddleware extends MiddlewareClass<AppState> {
  final DiagorienteUrlsRepository _repository;

  DiagorientePreferencesMetierMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId != null && action is DiagorientePreferencesMetierRequestAction) {
      store.dispatch(DiagorientePreferencesMetierLoadingAction());
      final result = await _repository.getUrls(userId);
      if (result != null) {
        store.dispatch(DiagorientePreferencesMetierSuccessAction(result));
      } else {
        store.dispatch(DiagorientePreferencesMetierFailureAction());
      }
    }
  }
}
