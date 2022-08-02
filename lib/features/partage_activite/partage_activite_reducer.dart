import 'package:pass_emploi_app/features/partage_activite/partage_activite_actions.dart';
import 'package:pass_emploi_app/features/partage_activite/partage_activites_state.dart';

PartageActiviteState partageActiviteReducer(PartageActiviteState currentState, dynamic action) {
  if (action is PartageActiviteRequestAction) {
    return PartageActiviteLoadingState();
  } else if (action is PartageActiviteLoadingAction) {
    return PartageActiviteLoadingState();
  } else if (action is PartageActiviteSuccessAction) {
    return PartageActiviteSuccessState(action.preferences);
  } else if (action is PartageActiviteFailureAction) {
    return PartageActiviteFailureState();
  } else {
    return currentState;
  }
}
