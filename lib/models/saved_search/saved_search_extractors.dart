import 'package:collection/collection.dart';
import 'package:redux/redux.dart';

import '../../redux/states/app_state.dart';
import '../../redux/states/immersion_search_request_state.dart';
import '../../redux/states/offre_emploi_search_parameters_state.dart';
import '../../redux/states/saved_search_state.dart';
import '../../ui/strings.dart';
import '../offre_emploi_filtres_parameters.dart';
import 'immersion_saved_search.dart';
import 'offre_emploi_saved_search.dart';

abstract class AbstractSearchExtractor<SAVED_SEARCH_MODEL> {
  SAVED_SEARCH_MODEL getSearchFilters(Store<AppState> store);

  bool isFailureState(Store<AppState> store);
}

class OffreEmploiSearchExtractor extends AbstractSearchExtractor<OffreEmploiSavedSearch> {
  @override
  OffreEmploiSavedSearch getSearchFilters(Store<AppState> store) {
    final state = store.state.offreEmploiSearchParametersState as OffreEmploiSearchParametersInitializedState;
    final metier = state.keywords;
    final location = state.location;
    String _title = _setTitleForOffer(metier, location?.libelle);
    return OffreEmploiSavedSearch(
      id: "",
      title: _title,
      metier: metier,
      location: location,
      keywords: metier,
      isAlternance: state.onlyAlternance,
      filters: OffreEmploiSearchParametersFiltres.withFiltres(
        distance: state.filtres.distance,
        experience: state.filtres.experience,
        duree: state.filtres.duree,
        contrat: state.filtres.contrat,
      ),
    );
  }

  @override
  bool isFailureState(Store<AppState> store) => store.state.offreEmploiSavedSearchState is SavedSearchFailureState;

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
    final requestState = store.state.immersionSearchRequestState as RequestedImmersionSearchRequestState;
    final String metier = _metier(store);
    final location = requestState.ville;
    return ImmersionSavedSearch(
      id: "",
      title: Strings.savedSearchTitleField(metier, location),
      metier: metier,
      location: location,
      filters: ImmersionSearchParametersFilters.withFilters(
        codeRome: requestState.codeRome,
        lat: requestState.latitude,
        lon: requestState.longitude,
      ),
    );
  }

  @override
  bool isFailureState(Store<AppState> store) => store.state.immersionSavedSearchState is SavedSearchFailureState;

  String _metier(Store<AppState> store) {
    final foundImmersions = store.state.immersionSearchState.getResultOrThrow();
    final searchedMetiers = store.state.searchMetierState.metiers;
    final requestState = store.state.immersionSearchRequestState as RequestedImmersionSearchRequestState;
    final matchingSearchedMetier = searchedMetiers.firstWhereOrNull((e) => e.codeRome == requestState.codeRome);
    if (foundImmersions.isNotEmpty) {
      return foundImmersions.first.metier;
    } else if (matchingSearchedMetier != null) {
      return matchingSearchedMetier.libelle;
    } else {
      return '';
    }
  }
}
