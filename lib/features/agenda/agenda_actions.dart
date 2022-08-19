import 'package:pass_emploi_app/models/agenda.dart';

class AgendaRequestAction {
  final DateTime maintenant;

  AgendaRequestAction(this.maintenant);
}

class AgendaRequestSuccessAction {
  final Agenda agenda;

  AgendaRequestSuccessAction(this.agenda);
}