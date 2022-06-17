import 'package:equatable/equatable.dart';

class PiecesJointesState extends Equatable {
  final Map<String, PieceJointeStatus> status;

  PiecesJointesState(this.status);

  PiecesJointesState updated(String id, PieceJointeStatus state) {
    final updatedData = status;
    updatedData.update(id, (value) => state, ifAbsent: () => state);
    return PiecesJointesState(updatedData);
  }

  @override
  List<Object?> get props => [status];
}

abstract class PieceJointeStatus extends Equatable {
  @override
  List<Object?> get props => [];
}

class PieceJointeLoadingStatus extends PieceJointeStatus {}

class PieceJointeSuccessStatus extends PieceJointeStatus {}

class PieceJointeFailureStatus extends PieceJointeStatus {}

class PieceJointeUnavailableStatus extends PieceJointeStatus {}
