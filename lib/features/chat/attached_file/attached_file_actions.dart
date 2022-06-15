class AttachedFileRequestAction {
  final String fileId;
  final String fileExtension;

  AttachedFileRequestAction(this.fileId, this.fileExtension);
}

class AttachedFileSuccessAction {
  final String fileId;

  AttachedFileSuccessAction(this.fileId);
}

class AttachedFileFailureAction {
  final String fileId;

  AttachedFileFailureAction(this.fileId);
}
