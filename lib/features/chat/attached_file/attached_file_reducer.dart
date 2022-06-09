import 'package:pass_emploi_app/features/chat/attached_file/attached_file_actions.dart';
import 'package:pass_emploi_app/features/chat/attached_file/attached_file_state.dart';

AttachedFileState attachedFileReducer(AttachedFileState current, dynamic action) {
  if (action is AttachedFileRequestAction) {
    final updatedData = current.data;
    updatedData.update(action.fileId, (value) => 'LOADING_STATE', ifAbsent: () => 'LOADING_STATE');
    return AttachedFileLoadingState(updatedData);
  } else if (action is AttachedFileFailureAction) {
    final updatedData = current.data;
    updatedData.update(action.fileId, (value) => 'FAILURE_STATE', ifAbsent: () => 'FAILURE_STATE');
    return AttachedFileFailureState(updatedData);
  } else if (action is AttachedFileSuccessAction) {
    final updatedData = current.data;
    updatedData.update(action.fileId, (value) => action.path, ifAbsent: () => action.path);
    return AttachedFileSuccessState(updatedData);
  }
  return current;
}