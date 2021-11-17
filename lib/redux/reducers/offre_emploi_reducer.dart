import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';

AppState offreEmploiReducer(AppState currentState, dynamic action) {
  if (action is SearchOffreEmploiAction) {
    return currentState.copyWith(
        offreEmploiSearchParametersState:
            OffreEmploiSearchParametersInitializedState(action.keywords, action.department));
  } else if (action is OffreEmploiSearchLoadingAction) {
    return currentState.copyWith(offreEmploiSearchState: OffreEmploiSearchState.loading());
  } else if (action is OffreEmploiSearchSuccessAction) {
    return currentState.copyWith(offreEmploiSearchState: OffreEmploiSearchState.success(action.offres));
  } else if (action is OffreEmploiSearchFailureAction) {
    return currentState.copyWith(offreEmploiSearchState: OffreEmploiSearchState.failure());
  } else {
    return currentState;
  }
}
