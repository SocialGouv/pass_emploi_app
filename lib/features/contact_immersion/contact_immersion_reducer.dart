import 'package:pass_emploi_app/features/contact_immersion/contact_immersion_actions.dart';
import 'package:pass_emploi_app/features/contact_immersion/contact_immersion_state.dart';

ContactImmersionState contactImmersionReducer(ContactImmersionState current, dynamic action) {
  if (action is ContactImmersionLoadingAction) return ContactImmersionLoadingState();
  if (action is ContactImmersionFailureAction) return ContactImmersionFailureState();
  if (action is ContactImmersionAlreadyDoneAction) return ContactImmersionAlreadyDoneState();
  if (action is ContactImmersionSuccessAction) return ContactImmersionSuccessState();
  if (action is ContactImmersionResetAction) return ContactImmersionNotInitializedState();
  return current;
}
