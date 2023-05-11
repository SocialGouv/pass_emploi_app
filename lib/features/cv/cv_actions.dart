import 'package:pass_emploi_app/models/cv_pole_emploi.dart';

class CvRequestAction {}

class CvLoadingAction {}

class CvSuccessAction {
  final List<CvPoleEmploi>? cvList;

  CvSuccessAction(this.cvList);
}

class CvFailureAction {}

class CvResetAction {}

class CvDownloadRequestAction {
  final CvPoleEmploi cv;

  CvDownloadRequestAction(this.cv);
}

class CvDownloadLoadingAction {
  final String url;

  CvDownloadLoadingAction(this.url);
}

class CvDownloadSuccessAction {
  final String url;
  final String filePath;

  CvDownloadSuccessAction(this.filePath, this.url);
}

class CvDownloadFailureAction {
  final String url;

  CvDownloadFailureAction(this.url);
}
