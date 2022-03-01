import 'package:pass_emploi_app/features/service_civique/search/search_service_civique_actions.dart';
import 'package:pass_emploi_app/features/service_civique/search/service_civique_search_result_state.dart';

ServiceCiviqueSearchResultState serviceCiviqueReducer(ServiceCiviqueSearchResultState current, dynamic action) {
  if (action is SearchServiceCiviqueAction) {
    return ServiceCiviqueSearchResultLoadingState();
  } else if (action is ServiceCiviqueSearchSuccessAction) {
    return ServiceCiviqueSearchResultDataState(
      isMoreDataAvailable: action.response.isMoreDataAvailable,
      lastRequest: action.response.lastRequest,
      offres: action.response.offres,
    );
  } else if (action is ServiceCiviqueSearchFailureAction) {
    return ServiceCiviqueSearchResultErrorState(action.failedRequest, action.previousOffers);
  } else if (action is ServiceCiviqueSearchResetAction) {
    return ServiceCiviqueSearchResultNotInitializedState();
  } else {
    return current;
  }
}
