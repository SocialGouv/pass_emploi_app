import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';

AppState offreEmploiReducer(AppState currentState, OffreEmploiAction action) {
  if (action is SearchOffreEmploiAction) {
    return _storeInitialSearchParameters(currentState, action);
  } else if (action is OffreEmploiSearchLoadingAction) {
    return currentState.copyWith(offreEmploiSearchState: OffreEmploiSearchState.loading());
  } else if (action is OffreEmploiSearchSuccessAction) {
    final previousSearchState = currentState.offreEmploiSearchResultsState;
    if (previousSearchState is OffreEmploiSearchResultsDataState) {
      return _appendNewOffres(currentState, previousSearchState, action);
    } else {
      return _storeOffres(currentState, action);
    }
  } else if (action is OffreEmploiSearchFailureAction) {
    return _searchStateFailure(currentState);
  } else if (action is OffreEmploiResetResultsAction) {
    return currentState.copyWith(
      offreEmploiSearchState: OffreEmploiSearchState.notInitialized(),
      offreEmploiSearchResultsState: OffreEmploiSearchResultsState.notInitialized(),
    );
  } else if (action is OffreEmploiSearchWithUpdateFiltresSuccessAction) {
    return _storeOffresWithUpdatedFiltres(currentState, action);
  } else if (action is OffreEmploiSearchUpdateFiltresAction) {
    final parametersState = currentState.offreEmploiSearchParametersState;
    if (parametersState is OffreEmploiSearchParametersInitializedState) {
      return _storeUpdatedFiltresSearchParameters(currentState, parametersState, action);
    } else {
      return currentState;
    }
  } else if (action is OffreEmploiSearchWithUpdateFiltresFailureAction) {
    final parametersState = currentState.offreEmploiSearchParametersState;
    if (parametersState is OffreEmploiSearchParametersInitializedState) {
      return _resetSearchAndFiltresState(currentState, parametersState);
    } else {
      return currentState;
    }
  } else {
    return currentState;
  }
}

AppState _storeOffres(AppState currentState, OffreEmploiSearchSuccessAction action) {
  return currentState.copyWith(
    offreEmploiSearchResultsState: OffreEmploiSearchResultsState.data(
      offres: action.offres,
      loadedPage: action.page,
      isMoreDataAvailable: action.isMoreDataAvailable,
    ),
    offreEmploiSearchState: OffreEmploiSearchState.success(),
  );
}

AppState _appendNewOffres(AppState currentState, OffreEmploiSearchResultsDataState previousSearchState,
    OffreEmploiSearchSuccessAction action) {
  return currentState.copyWith(
    offreEmploiSearchResultsState: OffreEmploiSearchResultsState.data(
      offres: previousSearchState.offres + action.offres,
      loadedPage: action.page,
      isMoreDataAvailable: action.isMoreDataAvailable,
    ),
    offreEmploiSearchState: OffreEmploiSearchState.success(),
  );
}

AppState _storeInitialSearchParameters(AppState currentState, SearchOffreEmploiAction action) {
  return currentState.copyWith(
      offreEmploiSearchParametersState: OffreEmploiSearchParametersInitializedState(
    keyWords: action.keywords,
    location: action.location,
    filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
  ));
}

AppState _storeUpdatedFiltresSearchParameters(AppState currentState,
    OffreEmploiSearchParametersInitializedState parametersState, OffreEmploiSearchUpdateFiltresAction action) {
  return currentState.copyWith(
      offreEmploiSearchParametersState: OffreEmploiSearchParametersInitializedState(
    keyWords: parametersState.keyWords,
    location: parametersState.location,
    filtres: action.updatedFiltres,
  ));
}

AppState _storeOffresWithUpdatedFiltres(AppState currentState, OffreEmploiSearchWithUpdateFiltresSuccessAction action) {
  return currentState.copyWith(
    offreEmploiSearchResultsState: OffreEmploiSearchResultsState.data(
      offres: action.offres,
      loadedPage: action.page,
      isMoreDataAvailable: action.isMoreDataAvailable,
    ),
    offreEmploiSearchState: OffreEmploiSearchState.success(),
  );
}

AppState _searchStateFailure(AppState currentState) {
  return currentState.copyWith(offreEmploiSearchState: OffreEmploiSearchState.failure());
}


AppState _resetSearchAndFiltresState(AppState currentState, OffreEmploiSearchParametersInitializedState parametersState) {
  return currentState.copyWith(
    offreEmploiSearchState: OffreEmploiSearchState.failure(),
    offreEmploiSearchParametersState: OffreEmploiSearchParametersState.initialized(
      parametersState.keyWords,
      parametersState.location,
      OffreEmploiSearchParametersFiltres.noFiltres(),
    ),
  );
}