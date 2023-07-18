import 'package:pass_emploi_app/models/session_milo_details.dart';

sealed class SessioMiloAction {}

class SessionMiloDetailsRequestAction extends SessioMiloAction {}

class SessionMiloDetailsLoadingAction extends SessioMiloAction {}

class SessionMiloDetailsSuccessAction extends SessioMiloAction {
  final SessionMiloDetails session;

  SessionMiloDetailsSuccessAction(this.session);
}

class SessionMiloDetailsFailureAction extends SessioMiloAction {}

class SessionMiloDetailsResetAction extends SessioMiloAction {}
