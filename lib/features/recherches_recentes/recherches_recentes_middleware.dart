import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherches_recentes/recherches_recentes_actions.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/models/alerte/evenement_emploi_alerte.dart';
import 'package:pass_emploi_app/models/alerte/immersion_alerte.dart';
import 'package:pass_emploi_app/models/alerte/offre_emploi_alerte.dart';
import 'package:pass_emploi_app/models/alerte/service_civique_alerte.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
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

    if (action is LoginSuccessAction) {
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
    final search = createAlerteFromRequest(action.request);
    if (search == null) return;

    var newList = List<Alerte>.from(store.state.recherchesRecentesState.recentSearches);
    newList.insert(0, search);
    newList = newList.take(50).toList();

    await _repository.save(newList);
    store.dispatch(RecherchesRecentesSuccessAction(newList));
  }
}

Alerte? createAlerteFromRequest(RechercheRequest request) {
  const id = "recherche-recente-id";
  if (request is RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche>) {
    return OffreEmploiAlerte(
      id: id,
      title: "${request.criteres.keyword} - ${request.criteres.location?.libelle ?? ''}",
      metier: null,
      location: request.criteres.location,
      keyword: request.criteres.keyword,
      onlyAlternance: request.criteres.rechercheType.isOnlyAlternance(),
      filters: request.filtres,
    );
  }
  if (request is RechercheRequest<ImmersionCriteresRecherche, ImmersionFiltresRecherche>) {
    return ImmersionAlerte(
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
    return ServiceCiviqueAlerte(
      id: id,
      titre: request.criteres.location?.libelle ?? "",
      ville: request.criteres.location?.libelle,
      location: request.criteres.location,
      filtres: ServiceCiviqueFiltresParameters.distance(request.filtres.distance),
      domaine: request.filtres.domain,
      dateDeDebut: request.filtres.startDate,
    );
  }
  if (request is RechercheRequest<EvenementEmploiCriteresRecherche, EvenementEmploiFiltresRecherche>) {
    return EvenementEmploiAlerte(
      id: id,
      titre: request.criteres.location.libelle,
      location: request.criteres.location,
    );
  }
  return null;
}
