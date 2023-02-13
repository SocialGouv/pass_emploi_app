import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/features/immersion/parameters/immersion_search_parameters_state.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_state.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/models/service_civique_filtres_pameters.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

abstract class AbstractSearchExtractor<SAVED_SEARCH_MODEL> {
  SAVED_SEARCH_MODEL getSearchFilters(Store<AppState> store);

  bool isFailureState(Store<AppState> store);
}

class OffreEmploiSearchExtractor extends AbstractSearchExtractor<OffreEmploiSavedSearch> {
  @override
  OffreEmploiSavedSearch getSearchFilters(Store<AppState> store) {
    //TODO(1353): peut-être cassé / crash si on clique sur "filtres" depuis une recherche sauvegardée parce que c'est un ancien écran qui n'utilise pas le state
    final state = store.state.rechercheEmploiState;
    final request = state.request!;
    final metier = request.criteres.keyword;
    final location = request.criteres.location;
    final String _title = _setTitleForOffer(metier, location?.libelle);
    return OffreEmploiSavedSearch(
      id: "",
      title: _title,
      metier: metier,
      location: location,
      keywords: metier,
      isAlternance: request.criteres.onlyAlternance,
      filters: OffreEmploiSearchParametersFiltres.withFiltres(
        distance: request.filtres.distance,
        debutantOnly: request.filtres.debutantOnly,
        experience: request.filtres.experience,
        duree: request.filtres.duree,
        contrat: request.filtres.contrat,
      ),
    );
  }

  @override
  bool isFailureState(Store<AppState> store) {
    return store.state.offreEmploiSavedSearchCreateState is SavedSearchCreateFailureState;
  }

  String _setTitleForOffer(String? metier, String? location) {
    if (_stringWithValue(metier) && _stringWithValue(location)) {
      return Strings.savedSearchTitleField(metier, location);
    } else if (_stringWithValue(metier)) {
      return metier!;
    } else if (_stringWithValue(location)) {
      return location!;
    } else {
      return '';
    }
  }

  bool _stringWithValue(String? str) => str != null && str.isNotEmpty;
}

class ImmersionSearchExtractor extends AbstractSearchExtractor<ImmersionSavedSearch> {
  @override
  ImmersionSavedSearch getSearchFilters(Store<AppState> store) {
    //TODO(1356): IF parce que la page des résultats d'une recherche sauvegardée n'utilise pas notre nouveau state/page
    // MAIS ça crash quand même quand quand on applique le filtre (la page FILTRE est maintenant basée sur le nouveau state)
    // DONC à discuter lundi :)

    //TODO(1356): en fonction du comment on adapte, refaire les tests ou en ajouter à côté

    if (store.state.immersionSearchParametersState is ImmersionSearchParametersInitializedState) {
      final parametersState = store.state.immersionSearchParametersState as ImmersionSearchParametersInitializedState;
      final String metier = _metier(store) ?? "";
      final ville = parametersState.location.libelle;
      return ImmersionSavedSearch(
        id: "",
        title: Strings.savedSearchTitleField(metier, ville),
        metier: metier,
        location: parametersState.location,
        ville: ville,
        codeRome: parametersState.codeRome,
        filtres: parametersState.filtres,
      );
    }
    final state = store.state.rechercheImmersionState;
    final String metier = state.request!.criteres.metier.libelle;
    final ville = state.request!.criteres.location.libelle;
    return ImmersionSavedSearch(
      id: "",
      title: Strings.savedSearchTitleField(metier, ville),
      metier: metier,
      location: state.request!.criteres.location,
      ville: ville,
      codeRome: state.request!.criteres.metier.codeRome,
      filtres: state.request!.filtres,
    );
  }

  @override
  bool isFailureState(Store<AppState> store) {
    return store.state.immersionSavedSearchCreateState is SavedSearchCreateFailureState;
  }

  String? _metier(Store<AppState> store) {
    final parametersState = store.state.immersionSearchParametersState as ImmersionSearchParametersInitializedState;
    if (parametersState.title != null) return parametersState.title!;
    final immersion = (store.state.immersionListState as ImmersionListSuccessState).immersions.firstOrNull;
    final searchedMetiers = store.state.searchMetierState.metiers;
    return searchedMetiers.firstWhereOrNull((element) => element.codeRome == parametersState.codeRome)?.libelle ??
        immersion?.metier;
  }
}

class ServiceCiviqueSearchExtractor extends AbstractSearchExtractor<ServiceCiviqueSavedSearch> {
  @override
  ServiceCiviqueSavedSearch getSearchFilters(Store<AppState> store) {
    final lastRequest = store.state.rechercheServiceCiviqueState.request;
    return ServiceCiviqueSavedSearch(
      id: "",
      titre: _savedSearchTitleField(lastRequest),
      location: lastRequest?.criteres.location,
      filtres: ServiceCiviqueFiltresParameters.distance(lastRequest?.filtres.distance),
      ville: lastRequest?.criteres.location?.libelle ?? "",
      domaine: lastRequest?.filtres.domain,
      dateDeDebut: lastRequest?.filtres.startDate,
    );
  }

  String _savedSearchTitleField(
      RechercheRequest<ServiceCiviqueCriteresRecherche, ServiceCiviqueFiltresRecherche>? lastRequest) {
    if (lastRequest == null) return "";
    final ville = lastRequest.criteres.location?.libelle;
    final domain = lastRequest.filtres.domain;
    if (ville != null && domain != null) {
      return Strings.savedSearchTitleField(domain, lastRequest.criteres.location?.libelle);
    } else if (ville != null) {
      return ville;
    } else if (domain != null) {
      return domain.tag;
    } else {
      return "";
    }
  }

  @override
  bool isFailureState(Store<AppState> store) {
    return store.state.serviceCiviqueSavedSearchCreateState is SavedSearchCreateFailureState;
  }
}
