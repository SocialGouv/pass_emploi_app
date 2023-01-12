import 'package:pass_emploi_app/features/demarche/list/demarche_list_actions.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/models/demarche.dart';

DemarcheListState demarcheListReducer(DemarcheListState current, dynamic action) {
  if (action is DemarcheListLoadingAction) return DemarcheListLoadingState();
  if (action is DemarcheListFailureAction) return DemarcheListFailureState();
  if (action is DemarcheListResetAction) return DemarcheListNotInitializedState();
  if (action is DemarcheListSuccessAction) {
    return DemarcheListSuccessState(action.demarches, action.dateDerniereMiseAJour);
  }
  if (action is UpdateDemarcheSuccessAction) return _listWithUpdatedDemarches(current, action.modifiedDemarche);
  return current;
}

DemarcheListState _listWithUpdatedDemarches(DemarcheListState current, Demarche modifiedDemarche) {
  if (current is DemarcheListSuccessState) {
    final currentDemarches = current.demarches.toList();
    final indexOfCurrentDemarche = currentDemarches.indexWhere((e) => e.id == modifiedDemarche.id);
    if (indexOfCurrentDemarche == -1) return current;
    currentDemarches[indexOfCurrentDemarche] = modifiedDemarche;
    return DemarcheListSuccessState(currentDemarches, current.dateDerniereMiseAJour);
  }
  return current;
}
