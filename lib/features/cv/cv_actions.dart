import 'package:pass_emploi_app/models/cv_pole_emploi.dart';

class CvRequestAction {}

class CvLoadingAction {}

class CvSuccessAction {
  final List<CvPoleEmploi>? cvList;

  CvSuccessAction(this.cvList);
}

class CvFailureAction {}

class CvResetAction {}
