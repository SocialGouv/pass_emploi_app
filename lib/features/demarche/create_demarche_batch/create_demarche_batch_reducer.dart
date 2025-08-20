import 'package:pass_emploi_app/features/demarche/create_demarche_batch/create_demarche_batch_actions.dart';
import 'package:pass_emploi_app/features/demarche/create_demarche_batch/create_demarche_batch_state.dart';

CreateDemarcheBatchState createDemarcheBatchReducer(CreateDemarcheBatchState current, dynamic action) {
  if (action is CreateDemarcheBatchLoadingAction) return CreateDemarcheBatchLoadingState();
  if (action is CreateDemarcheBatchFailureAction) return CreateDemarcheBatchFailureState();
  if (action is CreateDemarcheBatchSuccessAction) return CreateDemarcheBatchSuccessState();
  if (action is CreateDemarcheBatchResetAction) return CreateDemarcheBatchNotInitializedState();
  return current;
}
