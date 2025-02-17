import 'package:pass_emploi_app/features/auto_inscription/auto_inscription_actions.dart';
import 'package:pass_emploi_app/features/auto_inscription/auto_inscription_state.dart';

AutoInscriptionState autoInscriptionReducer(AutoInscriptionState current, dynamic action) {
  if (action is AutoInscriptionLoadingAction) return AutoInscriptionLoadingState();
  if (action is AutoInscriptionFailureAction) return AutoInscriptionFailureState(error: action.error);
  if (action is AutoInscriptionSuccessAction) return AutoInscriptionSuccessState();
  return current;
}
