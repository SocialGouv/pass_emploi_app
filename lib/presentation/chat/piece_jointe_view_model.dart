import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_actions.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_state.dart';
import 'package:pass_emploi_app/presentation/chat/chat_item.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class PieceJointeViewModel extends Equatable {
  final DisplayState Function(String fileId) displayState;
  final Function(PieceJointeConseillerMessageItem item) onClick;

  PieceJointeViewModel._({
    required this.displayState,
    required this.onClick,
  });

  factory PieceJointeViewModel.create(Store<AppState> store) {
    final piecesJointesState = store.state.piecesJointesState;
    return PieceJointeViewModel._(
      displayState: (fileId) => _displayState(fileId, piecesJointesState),
      onClick: (item) => store.dispatch(PieceJointeRequestAction(item.pieceJointeId, item.filename)),
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
