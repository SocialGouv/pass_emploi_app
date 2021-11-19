import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';

AppState offreEmploiReducer(AppState currentState, dynamic action) {
  if (action is SearchOffreEmploiAction) {
    return currentState.copyWith(
        offreEmploiSearchParametersState:
            OffreEmploiSearchParametersInitializedState(keyWords: action.keywords, department: action.department));
  } else if (action is OffreEmploiSearchLoadingAction) {
    return currentState.copyWith(offreEmploiSearchState: OffreEmploiSearchState.loading());
  } else if (action is OffreEmploiSearchSuccessAction) {
    final previousSearchState = currentState.offreEmploiSearchResultsState;
    if (previousSearchState is OffreEmploiSearchResultsNotInitializedState) {
      return currentState.copyWith(
        offreEmploiSearchResultsState: OffreEmploiSearchResultsState.data(action.offres, action.page),
        offreEmploiSearchState: OffreEmploiSearchState.success(),
      );
    } else if (previousSearchState is OffreEmploiSearchResultsDataState) {
      return currentState.copyWith(
        offreEmploiSearchResultsState:
            OffreEmploiSearchResultsState.data(previousSearchState.offres + action.offres, action.page),
        offreEmploiSearchState: OffreEmploiSearchState.success(),
      );
    } else {
      return currentState;
    }
  } else if (action is OffreEmploiSearchFailureAction) {
    return currentState.copyWith(offreEmploiSearchState: OffreEmploiSearchState.failure());
  } else {
    return currentState;
  }
}
