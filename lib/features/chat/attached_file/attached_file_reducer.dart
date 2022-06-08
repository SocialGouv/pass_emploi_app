import 'package:pass_emploi_app/features/chat/attached_file/attached_file_actions.dart';
import 'package:pass_emploi_app/features/chat/attached_file/attached_file_state.dart';

AttachedFileState attachedFileReducer(AttachedFileState current, dynamic action) {
  if (action is AttachedFileRequestAction) return AttachedFileLoadingState();
  if (action is AttachedFileFailureAction) return AttachedFileFailureState();
  // todo 679 how to not override data ?
  if (action is AttachedFileSuccessAction) return AttachedFileSuccessState({action.fileId:action.path});
  if (action is AttachedFileSuccessAction && current is AttachedFileSuccessState) {
    current.data.update(action.fileId, (value) => action.path);
    return AttachedFileSuccessState(current.data);
  }
  return current;
}
