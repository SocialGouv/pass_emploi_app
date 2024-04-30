import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_actions.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_state.dart';
import 'package:pass_emploi_app/features/tracking/tracking_event_action.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/presentation/chat/chat_page_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class PieceJointeViewModel extends Equatable {
  final DisplayState Function(String fileId) displayState;
  final String? Function(String fileId)? imagePath;
  final Function(String fileId, String fileName) onDownloadTypeId;
  final Function(String url, String fileId, String fileName) onDownloadTypeUrl;

  PieceJointeViewModel._({
    required this.displayState,
    this.imagePath,
    required this.onDownloadTypeId,
    required this.onDownloadTypeUrl,
  });

  factory PieceJointeViewModel.create(Store<AppState> store) {
    final piecesJointesState = store.state.piecesJointesState;
    return PieceJointeViewModel._(
      displayState: (fileId) => _displayState(fileId, piecesJointesState),
      imagePath: (fileId) => _imagePath(fileId, piecesJointesState),
      onDownloadTypeId: (fileId, fileName) => store.dispatch(PieceJointeFromIdRequestAction(fileId, fileName)),
      onDownloadTypeUrl: (url, fileId, fileName) => _onDownloadTypeUrl(url, fileId, fileName, store),
    );
  }

  @override
  List<Object?> get props => [displayState];
}

DisplayState _displayState(String id, PiecesJointesState piecesJointesState) {
  return switch (piecesJointesState.status[id]) {
    null => DisplayState.CONTENT,
    PieceJointeStatus.success => DisplayState.CONTENT,
    PieceJointeStatus.loading => DisplayState.LOADING,
    PieceJointeStatus.failure => DisplayState.FAILURE,
    PieceJointeStatus.unavailable => DisplayState.EMPTY,
  };
}

String? _imagePath(String id, PiecesJointesState piecesJointesState) {
  return switch (piecesJointesState.status[id]) {
    PieceJointeStatus.success => piecesJointesState.paths[id],
    _ => null,
  };
}

void _onDownloadTypeUrl(String url, String fileId, String fileName, Store<AppState> store) {
  store.dispatch(PieceJointeFromUrlRequestAction(url, fileId, fileName));
  if (!fileName.isImage()) {
    store.dispatch(TrackingEventAction(EventType.PIECE_JOINTE_TELECHARGEE));
  }
}
