import 'package:pass_emploi_app/models/cv_pole_emploi.dart';

class CvRequestAction {}

class CvLoadingAction {}

class CvSuccessAction {
  final List<CvPoleEmploi>? cvList;

  CvSuccessAction(this.cvList);
}

class CvFailureAction {}

class CvResetAction {}

class CvdownldRequestAction {
  final CvPoleEmploi cv;

  CvdownldRequestAction(this.cv);
}

class CvdownldLoadingAction {
  final String url;

  CvdownldLoadingAction(this.url);
}

class CvdownldSuccessAction {
  final String url;
  final String? filePath;

  CvdownldSuccessAction(this.filePath, this.url);
}

class CvdownldFailureAction {
  final String url;

  CvdownldFailureAction(this.url);
}
