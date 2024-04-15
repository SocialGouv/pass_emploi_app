import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_actions.dart';
import 'package:pass_emploi_app/features/chat/preview_file/preview_file_actions.dart';
import 'package:pass_emploi_app/features/chat/preview_file/preview_file_state.dart';
import 'package:pass_emploi_app/features/cv/cv_actions.dart';

PreviewFileState previewFileReducer(PreviewFileState current, dynamic action) {
  if (action is CvDownloadSuccessAction) return PreviewFileSuccessState(action.filePath);
  if (action is PieceJointeSuccessAction && !action.isImage) return PreviewFileSuccessState(action.path);
  if (action is PreviewFileCloseAction) return PreviewFileNotInitializedState();
  return current;
}
