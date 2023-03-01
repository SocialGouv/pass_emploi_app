import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/diagoriente_metiers_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/diagoriente_urls_repository.dart';
import 'package:redux/redux.dart';

class DiagorientePreferencesMetierMiddleware extends MiddlewareClass<AppState> {
  final DiagorienteUrlsRepository _diagorienteUrlRepository;
  final DiagorienteMetiersFavorisRepository _diagorienteMetiersFavorisRepository;

  DiagorientePreferencesMetierMiddleware(this._diagorienteUrlRepository, this._diagorienteMetiersFavorisRepository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId != null && action is DiagorientePreferencesMetierRequestAction) {
      store.dispatch(DiagorientePreferencesMetierLoadingAction());
      final urls = await _diagorienteUrlRepository.getUrls(userId);
      final aDesMetiersFavoris = await _diagorienteMetiersFavorisRepository.get(userId);
      if (urls != null && aDesMetiersFavoris != null) {
        store.dispatch(DiagorientePreferencesMetierSuccessAction(urls, aDesMetiersFavoris));
      } else {
        store.dispatch(DiagorientePreferencesMetierFailureAction());
      }
    }
  }
}
