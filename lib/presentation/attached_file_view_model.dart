import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/chat/attached_file/attached_file_actions.dart';
import 'package:pass_emploi_app/features/chat/attached_file/attached_file_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class AttachedFileViewModel extends Equatable {
  final Function(String fileId) displayState;
  final Function(String fileId) onClick;
  final String? Function(String fileId) getPath;

  AttachedFileViewModel._({
    required this.displayState,
    required this.onClick,
    required this.getPath,
  });

  factory AttachedFileViewModel.create(Store<AppState> store) {
    final attachedFileState = store.state.attachedFileState;
    return AttachedFileViewModel._(
      displayState: (fileId) => _displayState(fileId, attachedFileState),
      onClick: (fileId) => _dispatchRequestAction(store, fileId),
      getPath: (fileId) => _getPath(fileId, attachedFileState),
    );
  }

  @override
  List<Object?> get props => [displayState];
}

DisplayState _displayState(String id, AttachedFileState attachedFileState) {
  if (attachedFileState is AttachedFileSuccessState) {
    return attachedFileState.data.keys.firstWhere((element) => element == id).isNotEmpty
        ? DisplayState.CONTENT
        : DisplayState.EMPTY;
  } else if (attachedFileState is AttachedFileLoadingState) {
    return DisplayState.LOADING;
  } else {
    return DisplayState.FAILURE;
  }
}

String? _getPath(String id, AttachedFileState attachedFileState) {
  if (attachedFileState is AttachedFileSuccessState) {
    final String path = attachedFileState.data.keys.firstWhere((element) => element == id);
    return path != "LOADING_STATE" && path != "FAILURE_STATE" ? path : null;
  }
  return null;
}

void _dispatchRequestAction(Store<AppState> store, String fileId) {
  store.dispatch(AttachedFileRequestAction(fileId));
}
