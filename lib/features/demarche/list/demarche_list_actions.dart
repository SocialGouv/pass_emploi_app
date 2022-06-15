import 'package:pass_emploi_app/models/demarche.dart';

class DemarcheListRequestAction {}

class DemarcheListLoadingAction {}

class DemarcheListSuccessAction {
  final List<Demarche> demarches;
  final bool isDetailAvailable;

  DemarcheListSuccessAction(this.demarches, this.isDetailAvailable);
}

class DemarcheListFailureAction {}

class DemarcheListResetAction {}
