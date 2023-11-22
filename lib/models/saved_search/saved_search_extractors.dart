import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_state.dart';
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
    final state = store.state.rechercheEmploiState;
    final request = state.request!;
    final metier = request.criteres.keyword;
    final location = request.criteres.location;
    return OffreEmploiSavedSearch(
      id: "",
      title: _setTitleForOffer(metier, location?.libelle),
      metier: metier,
      location: location,
      keyword: metier,
      onlyAlternance: request.criteres.rechercheType.isOnlyAlternance(),
      filters: EmploiFiltresRecherche.withFiltres(
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
