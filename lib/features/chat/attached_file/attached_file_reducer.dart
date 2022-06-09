import 'package:pass_emploi_app/features/chat/attached_file/attached_file_actions.dart';
import 'package:pass_emploi_app/features/chat/attached_file/attached_file_state.dart';

AttachedFilesState attachedFileReducer(AttachedFilesState current, dynamic action) {
  if (action is AttachedFileRequestAction) {
    return current.updated(action.fileId, AttachedFileLoadingState());
  } else if (action is AttachedFileFailureAction) {
    return current.updated(action.fileId, AttachedFileFailureState());
  } else if (action is AttachedFileSuccessAction) {
    return current.updated(action.fileId, AttachedFileSuccessState(action.path));
  }
  return current;
}
