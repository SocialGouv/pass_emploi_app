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
  final currentFile = attachedFileState.data.entries.firstWhere((element) => element.key == id);
  if (currentFile.value == null || currentFile.value!.isEmpty) return DisplayState.EMPTY;
  if (currentFile.value == "LOADING_STATE") {
    return DisplayState.LOADING;
  } else if (currentFile.value == "FAILURE_STATE") {
    return DisplayState.FAILURE;
  } else {
    return DisplayState.CONTENT;
  }
}

String? _getPath(String id, AttachedFileState attachedFileState) {
  if (attachedFileState is AttachedFileSuccessState) {
    final currentFile = attachedFileState.data.entries.firstWhere((element) => element.key == id);
    return currentFile.value != "LOADING_STATE" && currentFile.value != "FAILURE_STATE" ? currentFile.value : null;
  }
  return null;
}

void _dispatchRequestAction(Store<AppState> store, String fileId) {
  store.dispatch(AttachedFileRequestAction(fileId));
}
