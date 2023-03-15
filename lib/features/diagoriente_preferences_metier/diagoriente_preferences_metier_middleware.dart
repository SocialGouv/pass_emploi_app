import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_actions.dart';
import 'package:pass_emploi_app/models/diagoriente_urls.dart';
import 'package:pass_emploi_app/models/metier.dart';
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

      final results = await Future.wait([
        _diagorienteUrlRepository.getUrls(userId),
        _diagorienteMetiersFavorisRepository.get(userId),
      ]);
      final urls = results[0] as DiagorienteUrls?;
      final metiersFavoris = results[1] as List<Metier>?;

      if (urls != null && metiersFavoris != null) {
        store.dispatch(DiagorientePreferencesMetierSuccessAction(urls, metiersFavoris));
      } else {
        store.dispatch(DiagorientePreferencesMetierFailureAction());
      }
    }
  }
}
