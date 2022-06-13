import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/chat/attached_file/attached_file_actions.dart';
import 'package:pass_emploi_app/features/chat/attached_file/attached_file_state.dart';
import 'package:pass_emploi_app/presentation/chat_item.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class AttachedFileViewModel extends Equatable {
  final DisplayState Function(String fileId) displayState;
  final Function(AttachedFileConseillerMessageItem item) onClick;

  AttachedFileViewModel._({
    required this.displayState,
    required this.onClick,
  });

  factory AttachedFileViewModel.create(Store<AppState> store) {
    final attachedFilesState = store.state.attachedFilesState;
    return AttachedFileViewModel._(
      displayState: (fileId) => _displayState(fileId, attachedFilesState),
      onClick: (item) => store.dispatch(AttachedFileRequestAction(item.id, item.filename.fileExtension())),
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

extension _FileExtension on String {
  String fileExtension() {
    return split(".").lastOrNull ?? "";
  }
}
