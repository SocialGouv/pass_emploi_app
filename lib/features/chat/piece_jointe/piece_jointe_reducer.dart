import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_actions.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_state.dart';

PiecesJointesState pieceJointeReducer(PiecesJointesState current, dynamic action) {
  if (action is PieceJointeRequestAction) {
    return current.updated(action.fileId, PieceJointeLoadingStatus());
  } else if (action is PieceJointeFailureAction) {
    return current.updated(action.fileId, PieceJointeFailureStatus());
  } else if (action is PieceJointeSuccessAction) {
    return current.updated(action.fileId, PieceJointeSuccessStatus());
  }
  return current;
}
