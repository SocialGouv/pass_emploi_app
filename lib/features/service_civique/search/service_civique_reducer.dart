import 'package:pass_emploi_app/features/service_civique/search/search_service_civique_actions.dart';
import 'package:pass_emploi_app/features/service_civique/search/service_civique_search_result_state.dart';

import '../../../redux/states/app_state.dart';

ServiceCiviqueSearchResultState serviceCiviqueReducer(AppState current, dynamic action) {
  if (action is SearchServiceCiviqueAction) {
    return ServiceCiviqueSearchResultLoadingState();
  } else if (action is ServiceCiviqueSuccessAction) {
    return ServiceCiviqueSearchResultState.fromResponse(action.response);
  } else if (action is ServiceCiviqueFailureAction) {
    return ServiceCiviqueSearchResultErrorState();
  } else {
    return current.serviceCiviqueSearchResultState;
  }
}
