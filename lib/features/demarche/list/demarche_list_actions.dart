import 'package:pass_emploi_app/models/demarche.dart';

class DemarcheListRequestAction {}

class DemarcheListLoadingAction {}

class DemarcheListSuccessAction {
  final List<Demarche> demarches;

  DemarcheListSuccessAction(this.demarches);
}

class DemarcheListFailureAction {}

class DemarcheListResetAction {}
