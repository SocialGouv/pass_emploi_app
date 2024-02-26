import 'package:pass_emploi_app/features/cvm/cvm_actions.dart';
import 'package:pass_emploi_app/features/cvm/cvm_state.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';

CvmState cvmReducer(CvmState current, dynamic action) {
  if (action is CvmLoadingAction) return CvmLoadingState();
  if (action is CvmFailureAction) return CvmFailureState();
  if (action is CvmSuccessAction) return CvmSuccessState(action.messages);
  if (action is RequestLogoutAction) return CvmNotInitializedState();
  return current;
}
