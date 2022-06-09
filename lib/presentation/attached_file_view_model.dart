import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/chat/attached_file/attached_file_actions.dart';
import 'package:pass_emploi_app/features/chat/attached_file/attached_file_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class AttachedFileViewModel extends Equatable {
  final DisplayState Function(String fileId) displayState;
  final Function(String fileId) onClick;
  final String? Function(String fileId) getPath;

  AttachedFileViewModel._({
    required this.displayState,
    required this.onClick,
    required this.getPath,
  });

  factory AttachedFileViewModel.create(Store<AppState> store) {
    final attachedFilesState = store.state.attachedFileState;
    return AttachedFileViewModel._(
      displayState: (fileId) => _displayState(fileId, attachedFilesState),
      onClick: (fileId) => _dispatchRequestAction(store, fileId),
      getPath: (fileId) => _getPath(fileId, attachedFilesState),
    );
  }

  @override
  List<Object?> get props => [displayState];
}

DisplayState _displayState(String id, AttachedFilesState attachedFilesState) {
  final status = attachedFilesState.status[id];
  if (status is AttachedFileLoadingStatus) {
    return DisplayState.LOADING;
  } else if (status is AttachedFileFailureStatus) {
    return DisplayState.FAILURE;
  } else if (status is AttachedFileSuccessStatus) {
    return DisplayState.CONTENT;
  }
  return DisplayState.EMPTY;
}

String? _getPath(String id, AttachedFilesState attachedFilesState) {
  final status = attachedFilesState.status[id];
  if (status is! AttachedFileSuccessStatus) {
    return null;
  }
  return status.path;
}

void _dispatchRequestAction(Store<AppState> store, String fileId) {
  store.dispatch(AttachedFileRequestAction(fileId));
}
