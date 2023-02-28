import 'package:pass_emploi_app/features/diagoriente_urls/diagoriente_urls_actions.dart';
import 'package:pass_emploi_app/features/diagoriente_urls/diagoriente_urls_state.dart';

DiagorienteUrlsState diagorienteUrlsReducer(DiagorienteUrlsState current, dynamic action) {
  if (action is DiagorienteUrlsLoadingAction) return DiagorienteUrlsLoadingState();
  if (action is DiagorienteUrlsFailureAction) return DiagorienteUrlsFailureState();
  if (action is DiagorienteUrlsSuccessAction) return DiagorienteUrlsSuccessState(action.result);
  if (action is DiagorienteUrlsResetAction) return DiagorienteUrlsNotInitializedState();
  return current;
}
