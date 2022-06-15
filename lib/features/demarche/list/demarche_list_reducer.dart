import 'package:pass_emploi_app/features/demarche/list/demarche_list_actions.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';

DemarcheListState demarcheListReducer(DemarcheListState current, dynamic action) {
  if (action is DemarcheListLoadingAction) return DemarcheListLoadingState();
  if (action is DemarcheListFailureAction) return DemarcheListFailureState();
  if (action is DemarcheSuccessUpdateAction) return DemarcheListSuccessState(action.userActions, true);
  if (action is DemarcheListResetAction) return DemarcheListNotInitializedState();
  if (action is DemarcheListSuccessAction) {
    return DemarcheListSuccessState(action.userActions, action.isDetailAvailable);
  }
  return current;
}
