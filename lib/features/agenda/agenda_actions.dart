import 'package:pass_emploi_app/models/agenda.dart';

class AgendaRequestAction {
  final DateTime maintenant;

  AgendaRequestAction(this.maintenant);
}

class AgendaRequestReloadAction {
  final DateTime maintenant;
  final bool forceRefresh;

  AgendaRequestReloadAction({required this.maintenant, this.forceRefresh = false});
}

class AgendaReloadingAction {}

class AgendaRequestFailureAction {}

class AgendaRequestSuccessAction {
  final Agenda agenda;

  AgendaRequestSuccessAction(this.agenda);
}
