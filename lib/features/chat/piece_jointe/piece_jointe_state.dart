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

enum PieceJointeStatus {
  loading, success, failure, unavailable
}
