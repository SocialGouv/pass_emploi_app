class PieceJointeTypeIdRequestAction {
  final String fileId;
  final String fileName;

  PieceJointeTypeIdRequestAction(this.fileId, this.fileName);
}

class PieceJointeTypeUrlRequestAction {
  final String fileId;
  final String url;

  PieceJointeTypeUrlRequestAction(this.fileId, this.url);
}

class PieceJointeSuccessAction {
  final String fileId;
  final String path;

  PieceJointeSuccessAction({required this.fileId, required this.path});
}

class PieceJointeUnavailableAction {
  final String fileId;

  PieceJointeUnavailableAction(this.fileId);
}

class PieceJointeFailureAction {
  final String fileId;

  PieceJointeFailureAction(this.fileId);
}
