import 'package:pass_emploi_app/features/chat/attached_file/attached_file_actions.dart';
import 'package:pass_emploi_app/features/chat/attached_file/attached_file_state.dart';

AttachedFilesState attachedFileReducer(AttachedFilesState current, dynamic action) {
  if (action is AttachedFileRequestAction) {
    return current.updated(action.fileId, AttachedFileLoadingStatus());
  } else if (action is AttachedFileFailureAction) {
    return current.updated(action.fileId, AttachedFileFailureStatus());
  } else if (action is AttachedFileSuccessAction) {
    return current.updated(action.fileId, AttachedFileSuccessStatus(action.path));
  }
  return current;
}
