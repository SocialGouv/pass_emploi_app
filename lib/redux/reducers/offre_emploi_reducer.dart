import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';

AppState offreEmploiReducer(AppState currentState, OffreEmploiAction action) {
  if (action is SearchOffreEmploiAction) {
    return _storeSearchParameters(currentState, action);
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
    return currentState.copyWith(offreEmploiSearchState: OffreEmploiSearchState.failure());
  } else if (action is OffreEmploiResetResultsAction) {
    return currentState.copyWith(
      offreEmploiSearchState: OffreEmploiSearchState.notInitialized(),
      offreEmploiSearchResultsState: OffreEmploiSearchResultsState.notInitialized(),
    );
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

AppState _storeSearchParameters(AppState currentState, SearchOffreEmploiAction action) {
  return currentState.copyWith(
      offreEmploiSearchParametersState:
          OffreEmploiSearchParametersInitializedState(keyWords: action.keywords, location: action.location));
}
