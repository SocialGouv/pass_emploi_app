class AttachedFileRequestAction {
  final String fileId;
  final String fileExtension;

  AttachedFileRequestAction(this.fileId, this.fileExtension);
}

class AttachedFileSuccessAction {
  final String fileId;
  final String path;

  AttachedFileSuccessAction(this.fileId, this.path);
}

class AttachedFileFailureAction {
  final String fileId;

  AttachedFileFailureAction(this.fileId);
}
