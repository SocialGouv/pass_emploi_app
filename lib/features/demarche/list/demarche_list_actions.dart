import 'package:pass_emploi_app/models/demarche.dart';

class DemarcheListRequestAction {}

class DemarcheListLoadingAction {}

class DemarcheListSuccessAction {
  final List<Demarche> userActions;
  final bool isDetailAvailable;

  DemarcheListSuccessAction(this.userActions, this.isDetailAvailable);
}

class DemarcheListFailureAction {}

class DemarcheListResetAction {}
