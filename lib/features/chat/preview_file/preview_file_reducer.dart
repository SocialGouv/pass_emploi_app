import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_actions.dart';
import 'package:pass_emploi_app/features/chat/preview_file/preview_file_actions.dart';
import 'package:pass_emploi_app/features/chat/preview_file/preview_file_state.dart';

PreviewFileState previewFileReducer(PreviewFileState current, dynamic action) {
  // TODO: add cvdownld
  if (action is PieceJointeSuccessAction) return PreviewFileSuccessState(action.path);
  if (action is PreviewFileCloseAction) return PreviewFileNotInitializedState();
  return current;
}
