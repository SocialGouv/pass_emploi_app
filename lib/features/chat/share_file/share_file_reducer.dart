import 'package:pass_emploi_app/features/chat/share_file/share_file_actions.dart';
import 'package:pass_emploi_app/features/chat/share_file/share_file_state.dart';

ShareFileState shareFileReducer(ShareFileState current, dynamic action) {
  if (action is ShareFileAction) {
    return ShareFileSuccessState(action.path);
  } else if (action is ShareFileCloseAction) {
    return ShareFileNotInitializedState();
  }
  return current;
}