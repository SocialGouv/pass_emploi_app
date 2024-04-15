import 'package:equatable/equatable.dart';

class PiecesJointesState extends Equatable {
  final Map<String, PieceJointeStatus> status;
  final Map<String, String?> paths;

  PiecesJointesState(this.status, this.paths);

  PiecesJointesState updated(String id, PieceJointeStatus state, {String? path}) {
    final updatedData = status;
    updatedData.update(id, (value) => state, ifAbsent: () => state);

    final updatedPaths = paths;
    updatedPaths.update(id, (value) => path, ifAbsent: () => path);

    return PiecesJointesState(updatedData, updatedPaths);
  }

  @override
  List<Object?> get props => [status, paths];
}

enum PieceJointeStatus { loading, success, failure, unavailable }
