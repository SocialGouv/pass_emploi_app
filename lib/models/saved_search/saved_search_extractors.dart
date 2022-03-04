import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_state.dart';
import 'package:redux/redux.dart';

import '../../features/immersion/search/immersion_search_state.dart';
import '../../features/offre_emploi/parameters/offre_emploi_search_parameters_state.dart';
import '../../redux/app_state.dart';
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
    final String metier = _metier(store);
    final location = parametersState.ville;
    return ImmersionSavedSearch(
      id: "",
      title: Strings.savedSearchTitleField(metier, location),
      metier: metier,
      location: location,
      filters: ImmersionSearchParametersFilters.withFilters(
        codeRome: parametersState.codeRome,
        lat: parametersState.location.latitude,
        lon: parametersState.location.longitude,
      ),
    );
  }

  @override
  bool isFailureState(Store<AppState> store) {
    return store.state.immersionSavedSearchCreateState is SavedSearchCreateFailureState;
  }

  String _metier(Store<AppState> store) {
    final parametersState = store.state.immersionSearchParametersState as ImmersionSearchParametersInitializedState;
    if (requestState.title != null) return requestState.title!;
    final immersion = (store.state.immersionListState as ImmersionListSuccessState).immersions.first;
    final searchedMetiers = store.state.searchMetierState.metiers;
    return searchedMetiers.firstWhereOrNull((element) => element.codeRome == parametersState.codeRome)?.libelle ??
        immersion.metier;
  }
}
