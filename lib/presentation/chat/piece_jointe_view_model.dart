import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_actions.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class PieceJointeViewModel extends Equatable {
  final DisplayState Function(String fileId) displayState;
  final Function(String fileId, String fileName) onDownloadTypeId;
  final Function(String url, String fileId, String fileName) onDownloadTypeUrl;

  PieceJointeViewModel._({
    required this.displayState,
    required this.onDownloadTypeId,
    required this.onDownloadTypeUrl,
  });

  factory PieceJointeViewModel.create(Store<AppState> store) {
    final piecesJointesState = store.state.piecesJointesState;
    return PieceJointeViewModel._(
      displayState: (fileId) => _displayState(fileId, piecesJointesState),
      onDownloadTypeId: (fileId, fileName) => store.dispatch(PieceJointeFromIdRequestAction(fileId, fileName)),
      onDownloadTypeUrl: (url, fileId, fileName) => store.dispatch(
        PieceJointeFromUrlRequestAction(url, fileId, fileName),
      ),
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
