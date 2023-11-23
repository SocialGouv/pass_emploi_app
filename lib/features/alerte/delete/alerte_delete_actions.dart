class AlerteDeleteRequestAction {
  final String alerteId;

  AlerteDeleteRequestAction(this.alerteId);
}

class AlerteDeleteLoadingAction {}

class AlerteDeleteSuccessAction {
  final String alerteId;

  AlerteDeleteSuccessAction(this.alerteId);
}

class AlerteDeleteFailureAction {}

class AlerteDeleteResetAction {}
