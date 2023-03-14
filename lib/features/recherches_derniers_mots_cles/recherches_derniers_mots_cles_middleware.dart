import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherches_derniers_mots_cles/recherches_derniers_mots_cles_actions.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/recherches_derniers_mots_cles_repository.dart';
import 'package:redux/redux.dart';

class RecherchesDerniersMotsClesMiddleware extends MiddlewareClass<AppState> {
  final RecherchesDerniersMotsClesRepository _repository;

  RecherchesDerniersMotsClesMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is RechercheSuccessAction<EmploiCriteresRecherche, EmploiFiltresRecherche, OffreEmploi>) {
      await _saveLastMotCle(action, store);
    }

    if (action is RecherchesDerniersMotsClesRequestAction) {
      await _loadDerniersMotsCles(store);
    }
  }

  Future<void> _loadDerniersMotsCles(Store<AppState> store) async {
    final motsCles = await _repository.getDerniersMotsCles();
    store.dispatch(RecherchesDerniersMotsClesSuccessAction(motsCles));
  }

  Future<void> _saveLastMotCle(
      RechercheSuccessAction<EmploiCriteresRecherche, EmploiFiltresRecherche, OffreEmploi> action,
      Store<AppState> store) async {
    final motCle = action.request.criteres.keyword;
    final derniersMotsCles = List<String>.from(store.state.recherchesDerniersMotsClesState.motsCles);

    if (derniersMotsCles.contains(motCle)) {
      derniersMotsCles.remove(motCle);
    }

    derniersMotsCles.insert(0, motCle);

    if (derniersMotsCles.length > 3) {
      derniersMotsCles.removeRange(3, derniersMotsCles.length);
    }

    await _repository.saveDernierMotsCles(derniersMotsCles);
    store.dispatch(RecherchesDerniersMotsClesSuccessAction(derniersMotsCles));
  }
}
