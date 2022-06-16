import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_actions.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_state.dart';
import 'package:pass_emploi_app/presentation/chat_item.dart';
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
    final attachedFilesState = store.state.attachedFilesState;
    return PieceJointeViewModel._(
      displayState: (fileId) => _displayState(fileId, attachedFilesState),
      onClick: (item) => store.dispatch(PieceJointeRequestAction(item.id, item.filename)),
    );
  }

  @override
  List<Object?> get props => [displayState];
}

DisplayState _displayState(String id, PiecesJointesState attachedFilesState) {
  final status = attachedFilesState.status[id];
  if (status is PieceJointeLoadingStatus) {
    return DisplayState.LOADING;
  } else if (status is PieceJointeFailureStatus) {
    return DisplayState.FAILURE;
  } else if (status is PieceJointeSuccessStatus) {
    return DisplayState.CONTENT;
  }
  return DisplayState.EMPTY;
}
