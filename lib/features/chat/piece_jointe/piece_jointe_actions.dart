class PieceJointeFromIdRequestAction {
  final String fileId;
  final String fileName;
  final bool isImage;

  PieceJointeFromIdRequestAction(this.fileId, this.fileName, {this.isImage = false});
}

class PieceJointeFromUrlRequestAction {
  final String url;
  final String fileId;
  final String fileName;

  PieceJointeFromUrlRequestAction(this.url, this.fileId, this.fileName);
}

class PieceJointeSuccessAction {
  final String fileId;
  final String path;
  final bool isImage;

  PieceJointeSuccessAction({required this.fileId, required this.path, this.isImage = false});
}

class PieceJointeUnavailableAction {
  final String fileId;

  PieceJointeUnavailableAction(this.fileId);
}

class PieceJointeFailureAction {
  final String fileId;

  PieceJointeFailureAction(this.fileId);
}
