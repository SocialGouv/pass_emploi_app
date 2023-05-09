import 'package:pass_emploi_app/features/cv/cv_actions.dart';
import 'package:pass_emploi_app/features/cv/cv_state.dart';

CvState cvReducer(CvState current, dynamic action) {
  if (action is CvLoadingAction) return CvLoadingState();
  if (action is CvFailureAction) return CvFailureState();
  if (action is CvSuccessAction) return CvSuccessState(action.cvList);
  if (action is CvResetAction) return CvNotInitializedState();
  return current;
}
