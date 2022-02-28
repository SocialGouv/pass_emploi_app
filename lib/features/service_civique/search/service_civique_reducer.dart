import 'package:pass_emploi_app/features/service_civique/search/search_service_civique_actions.dart';
import 'package:pass_emploi_app/features/service_civique/search/service_civique_search_result_state.dart';

ServiceCiviqueSearchResultState serviceCiviqueReducer(ServiceCiviqueSearchResultState current, dynamic action) {
  if (action is SearchServiceCiviqueAction) {
    return ServiceCiviqueSearchResultLoadingState();
  } else if (action is ServiceCiviqueSearchSuccessAction) {
    return ServiceCiviqueSearchResultDataState(
      isMoreDataAvailable: action.response.isMoreDataAvailable,
      loadedPage: action.response.lastPageRequested,
      offres: action.response.offres,
    );
  } else if (action is ServiceCiviqueSearchFailureAction) {
    return ServiceCiviqueSearchResultErrorState();
  } else {
    return current;
  }
}
