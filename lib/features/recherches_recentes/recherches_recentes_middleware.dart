import 'package:equatable/src/equatable.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherches_recentes/recherches_recentes_actions.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/models/service_civique_filtres_pameters.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/recherches_recentes_repository.dart';
import 'package:redux/redux.dart';

class RecherchesRecentesMiddleware extends MiddlewareClass<AppState> {
  final RecherchesRecentesRepository _repository;

  RecherchesRecentesMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId == null) return;

    if (action is RecherchesRecentesRequestAction) {
      final result = await _repository.get();
      store.dispatch(RecherchesRecentesSuccessAction(result));
    } else if (action is RechercheSuccessAction) {
      await addToRecentSearch(action, store);
    }
  }

  Future<void> addToRecentSearch(
    RechercheSuccessAction<Equatable, Equatable, dynamic> action,
    Store<AppState> store,
  ) async {
    final search = createSavedSearchFromRequest(action.request);
    if (search == null) return;

    var newList = List<SavedSearch>.from(store.state.recherchesRecentesState.recentSearches);
    newList.insert(0, search);
    newList = newList.take(50).toList();

    await _repository.save(newList);
    store.dispatch(RecherchesRecentesSuccessAction(newList));
  }
}

SavedSearch? createSavedSearchFromRequest(RechercheRequest request) {
  const id = "recherche-recente-id";
  if (request is RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche>) {
    return OffreEmploiSavedSearch(
      id: id,
      title: "${request.criteres.keyword} - ${request.criteres.location?.libelle ?? ''}",
      metier: null,
      location: request.criteres.location,
      keyword: request.criteres.keyword,
      onlyAlternance: request.criteres.onlyAlternance,
      filters: request.filtres,
    );
  }
  if (request is RechercheRequest<ImmersionCriteresRecherche, ImmersionFiltresRecherche>) {
    return ImmersionSavedSearch(
      id: id,
      title: "${request.criteres.metier.libelle} - ${request.criteres.location.libelle}",
      codeRome: request.criteres.metier.codeRome,
      metier: request.criteres.metier.libelle,
      location: request.criteres.location,
      ville: request.criteres.location.libelle,
      filtres: request.filtres,
    );
  }
  if (request is RechercheRequest<ServiceCiviqueCriteresRecherche, ServiceCiviqueFiltresRecherche>) {
    return ServiceCiviqueSavedSearch(
      id: id,
      titre: request.criteres.location?.libelle ?? "",
      ville: request.criteres.location?.libelle,
      location: request.criteres.location,
      filtres: ServiceCiviqueFiltresParameters.distance(request.filtres.distance),
      domaine: request.filtres.domain,
      dateDeDebut: request.filtres.startDate,
    );
  }
  return null;
}
