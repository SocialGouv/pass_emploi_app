import 'package:pass_emploi_app/models/demarche.dart';

class DemarcheListRequestAction {}

class DemarcheListLoadingAction {}

class DemarcheListSuccessAction {
  final List<Demarche> demarches;
  final bool isFonctionnalitesAvanceesJreActivees;

  DemarcheListSuccessAction(this.demarches, this.isFonctionnalitesAvanceesJreActivees);
}

class DemarcheListFailureAction {}

class DemarcheListResetAction {}
