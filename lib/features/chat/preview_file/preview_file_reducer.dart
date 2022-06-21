import 'package:pass_emploi_app/features/chat/preview_file/preview_file_actions.dart';
import 'package:pass_emploi_app/features/chat/preview_file/preview_file_state.dart';

PreviewFileState previewFileReducer(PreviewFileState current, dynamic action) {
  if (action is PreviewFileAction) {
    return PreviewFileSuccessState(action.path);
  } else if (action is PreviewFileCloseAction) {
    return PreviewFileNotInitializedState();
  }
  return current;
}