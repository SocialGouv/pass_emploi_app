import 'package:pass_emploi_app/models/agenda.dart';

class AgendaRequestAction {
  final DateTime maintenant;

  AgendaRequestAction(this.maintenant);
}

class AgendaRequestReloadAction {
  final DateTime maintenant;

  AgendaRequestReloadAction(this.maintenant);
}

class AgendaReloadingAction {}

class AgendaRequestFailureAction {}

class AgendaRequestSuccessAction {
  final Agenda agenda;

  AgendaRequestSuccessAction(this.agenda);
}
