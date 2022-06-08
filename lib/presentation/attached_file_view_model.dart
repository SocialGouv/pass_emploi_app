import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/chat/attached_file/attached_file_actions.dart';
import 'package:pass_emploi_app/features/chat/attached_file/attached_file_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class AttachedFileViewModel extends Equatable {
  final Function(String fileId) displayState;
  final Function(String fileId) onClick;

  AttachedFileViewModel._({
    required this.displayState,
    required this.onClick,
  });

  factory AttachedFileViewModel.create(Store<AppState> store) {
    final attachedFileState = store.state.attachedFileState;
    return AttachedFileViewModel._(
      displayState: (fileId) => _displayState(fileId, attachedFileState),
      onClick: (fileId) => _dispatchRequestAction(store, fileId),
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

void _dispatchRequestAction(Store<AppState> store, String fileId) {
  store.dispatch(AttachedFileRequestAction(fileId));
}
