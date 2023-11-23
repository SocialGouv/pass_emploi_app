import 'package:pass_emploi_app/models/alerte/alerte.dart';

class AlerteListRequestAction {}

class AlerteListLoadingAction {}

class AlerteListSuccessAction {
  final List<Alerte> alertes;

  AlerteListSuccessAction(this.alertes);
}

class AlerteListFailureAction {}

class AlerteListResetAction {}
