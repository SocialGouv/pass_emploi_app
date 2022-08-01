import 'package:pass_emploi_app/features/partage_activite/update/partage_activite_update_actions.dart';
import 'package:pass_emploi_app/features/partage_activite/update/partage_activite_update_state.dart';

PartageActiviteUpdateState partageActiviteUpdateReducer(PartageActiviteUpdateState currentState, dynamic action) {
  if (action is PartageActiviteUpdateRequestAction) {
    return PartageActiviteUpdateLoadingState();
  } else if (action is PartageActiviteUpdateLoadingAction) {
    return PartageActiviteUpdateLoadingState();
  } else if (action is PartageActiviteUpdateSuccessAction) {
    return PartageActiviteUpdateSuccessState(action.favorisShared);
  } else if (action is PartageActiviteUpdateFailureAction) {
    return PartageActiviteUpdateFailureState();
  } else {
    return currentState;
  }
}
