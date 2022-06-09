class AttachedFileRequestAction {
  final String fileId;

  AttachedFileRequestAction(this.fileId);
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
