class AttachedFileRequestAction {
  final String fileId;
  final String fileName;

  AttachedFileRequestAction(this.fileId, this.fileName);
}

class AttachedFileSuccessAction {
  final String fileId;

  AttachedFileSuccessAction(this.fileId);
}

class AttachedFileFailureAction {
  final String fileId;

  AttachedFileFailureAction(this.fileId);
}
