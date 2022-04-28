import 'package:pass_emploi_app/features/suppression_compte/suppression_compte_action.dart';
import 'package:pass_emploi_app/features/suppression_compte/suppression_compte_state.dart';

SuppressionCompteState suppressionCompteReducer(SuppressionCompteState current, dynamic action) {
  if (action is SuppressionCompteLoadingAction) return SuppressionCompteLoadingState();
  if (action is SuppressionCompteFailureAction) return SuppressionCompteFailureState();
  if (action is SuppressionCompteSuccessAction) return SuppressionCompteSuccessState();
  return current;
}