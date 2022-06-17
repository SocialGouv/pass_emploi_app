class PieceJointeRequestAction {
  final String fileId;
  final String fileName;

  PieceJointeRequestAction(this.fileId, this.fileName);
}

class PieceJointeSuccessAction {
  final String fileId;

  PieceJointeSuccessAction(this.fileId);
}

class PieceJointeUnavailableAction {
  final String fileId;

  PieceJointeUnavailableAction(this.fileId);
}

class PieceJointeFailureAction {
  final String fileId;

  PieceJointeFailureAction(this.fileId);
}
