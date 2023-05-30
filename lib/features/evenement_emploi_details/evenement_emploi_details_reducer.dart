import 'package:pass_emploi_app/features/evenement_emploi_details/evenement_emploi_details_actions.dart';
import 'package:pass_emploi_app/features/evenement_emploi_details/evenement_emploi_details_state.dart';

EvenementEmploiDetailsState evenementEmploiDetailsReducer(EvenementEmploiDetailsState current, dynamic action) {
  if (action is EvenementEmploiDetailsLoadingAction) return EvenementEmploiDetailsLoadingState();
  if (action is EvenementEmploiDetailsFailureAction) return EvenementEmploiDetailsFailureState();
  if (action is EvenementEmploiDetailsSuccessAction) return EvenementEmploiDetailsSuccessState(action.details);
  if (action is EvenementEmploiDetailsResetAction) return EvenementEmploiDetailsNotInitializedState();
  return current;
}
