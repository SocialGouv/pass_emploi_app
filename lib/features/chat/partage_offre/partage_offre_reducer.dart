import 'package:pass_emploi_app/features/chat/partage_offre/partage_offre_actions.dart';
import 'package:pass_emploi_app/features/chat/partage_offre/partage_offre_state.dart';

ChatPartageOffreState chatPartageOffreReducer(ChatPartageOffreState current, dynamic action) {
  if (action is ChatPartageOffreLoadingAction) return ChatPartageOffreState.loading;
  if (action is ChatPartageOffreResetAction) return ChatPartageOffreState.notInitialized;
  if (action is ChatPartageOffreSuccessAction) return ChatPartageOffreState.success;
  if (action is ChatPartageOffreFailureAction) return ChatPartageOffreState.failure;
  return current;
}