import 'package:pass_emploi_app/features/immersion/details/immersion_details_actions.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_state.dart';

ImmersionDetailsState immersionDetailsReducer(ImmersionDetailsState current, dynamic action) {
  if (action is ImmersionDetailsIncompleteDataAction) return ImmersionDetailsIncompleteDataState(action.immersion);
  if (action is ImmersionDetailsLoadingAction) return ImmersionDetailsLoadingState();
  if (action is ImmersionDetailsFailureAction) return ImmersionDetailsFailureState();
  if (action is ImmersionDetailsSuccessAction) return ImmersionDetailsSuccessState(action.immersion);
  return current;
}
