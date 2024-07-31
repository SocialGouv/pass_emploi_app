import 'package:pass_emploi_app/features/cgu/cgu_actions.dart';
import 'package:pass_emploi_app/features/cgu/cgu_state.dart';

CguState cguReducer(CguState current, dynamic action) {
  if (action is CguNeverAcceptedAction) return CguNeverAcceptedState();
  if (action is CguAlreadyAcceptedAction) return CguAlreadyAcceptedState();
  if (action is CguUpdateRequiredAction) return CguUpdateRequiredState(action.updatedCgu);
  return current;
}
