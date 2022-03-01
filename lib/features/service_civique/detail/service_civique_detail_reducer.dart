import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_actions.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_state.dart';

ServiceCiviqueDetailState serviceCiviqueDetailReducer(ServiceCiviqueDetailState current, dynamic action) {
  if (action is ServiceCiviqueDetailLoadingAction) {
    return ServiceCiviqueDetailLoadingState();
  } else if (action is ServiceCiviqueDetailSuccessAction) {
    return ServiceCiviqueDetailSuccessState(action.detail);
  } else if (action is ServiceCiviqueDetailFailureAction) {
    return ServiceCiviqueDetailFailureState();
  } else {
    return current;
  }
}
