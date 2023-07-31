import 'package:pass_emploi_app/features/session_milo_details/session_milo_details_actions.dart';
import 'package:pass_emploi_app/features/session_milo_details/session_milo_details_state.dart';

SessionMiloDetailsState sessionMiloDetailsReducer(SessionMiloDetailsState current, dynamic action) {
  if (action is SessionMiloDetailsLoadingAction) return SessionMiloDetailsLoadingState();
  if (action is SessionMiloDetailsFailureAction) return SessionMiloDetailsFailureState();
  if (action is SessionMiloDetailsSuccessAction) return SessionMiloDetailsSuccessState(action.session);
  if (action is SessionMiloDetailsResetAction) return SessionMiloDetailsNotInitializedState();
  return current;
}
