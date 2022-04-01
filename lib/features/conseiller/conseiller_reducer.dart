import 'package:pass_emploi_app/features/conseiller/conseiller_actions.dart';
import 'package:pass_emploi_app/features/conseiller/conseiller_state.dart';

ConseillerState conseillerReducer(ConseillerState current, dynamic action) {
  if (action is ConseillerLoadingAction) return ConseillerLoadingState();
  if (action is ConseillerSuccessAction) return ConseillerSuccessState(conseillerInfo: action.conseillerInfo);
  if (action is ConseillerFailureAction) return ConseillerFailureState();
  return current;
}



