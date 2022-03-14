import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/features/immersion/parameters/immersion_search_parameters_state.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_state.dart';
import 'package:redux/redux.dart';

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
