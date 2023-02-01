import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/features/immersion/parameters/immersion_search_parameters_state.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_state.dart';
import 'package:pass_emploi_app/features/service_civique/search/service_civique_search_result_state.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/models/service_civique/domain.dart';
import 'package:pass_emploi_app/models/service_civique_filtres_pameters.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/service_civique_repository.dart';
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
    final metier = request.criteres.keywords;
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
    final parametersState = store.state.immersionSearchParametersState as ImmersionSearchParametersInitializedState;
    final String metier = _metier(store) ?? "";
    final ville = parametersState.location?.libelle ?? "";
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
    final lastRequest =
        (store.state.serviceCiviqueSearchResultState as ServiceCiviqueSearchResultDataState).lastRequest;
    return ServiceCiviqueSavedSearch(
      id: "",
      titre: _savedSearchTitleField(lastRequest),
      location: lastRequest.location,
      filtres: ServiceCiviqueFiltresParameters.distance(lastRequest.distance),
      ville: lastRequest.location?.libelle ?? "",
      domaine: Domaine.fromTag(lastRequest.domain),
      dateDeDebut: lastRequest.startDate,
    );
  }

  String _savedSearchTitleField(SearchServiceCiviqueRequest lastRequest) {
    final ville = lastRequest.location?.libelle;
    final domain = lastRequest.domain;
    if (ville != null && domain != null) {
      return Strings.savedSearchTitleField(domain, lastRequest.location?.libelle);
    } else if (ville != null) {
      return ville;
    } else if (domain != null) {
      return domain;
    } else {
      return "";
    }
  }

  @override
  bool isFailureState(Store<AppState> store) {
    return store.state.serviceCiviqueSavedSearchCreateState is SavedSearchCreateFailureState;
  }
}
