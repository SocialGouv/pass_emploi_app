import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/features/accueil/accueil_state.dart';

AccueilState accueilReducer(AccueilState current, dynamic action) {
  if (action is AccueilLoadingAction) return AccueilLoadingState();
  if (action is AccueilFailureAction) return AccueilFailureState();
  if (action is AccueilSuccessAction) return AccueilSuccessState(action.accueil);
  if (action is AccueilResetAction) return AccueilNotInitializedState();
  return current;
}
