import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

Demarche getDemarche(Store<AppState> store, DemarcheStateSource stateSource, String demarcheId) {
  switch (stateSource) {
    case DemarcheStateSource.agenda:
      return _getFromAgendaState(store, demarcheId);
    case DemarcheStateSource.list:
      return _getFromDemarcheState(store, demarcheId);
  }
}

Demarche _getFromAgendaState(Store<AppState> store, String demarcheId) {
  final state = store.state.agendaState;
  if (state is! AgendaSuccessState) throw Exception('Invalid state.');
  final demarche = state.agenda.demarches.where((e) => e.id == demarcheId).firstOrNull;
  if (demarche == null) throw Exception('No UserAction matching id $demarcheId');
  return demarche;
}

Demarche _getFromDemarcheState(Store<AppState> store, String demarcheId) {
  final state = store.state.demarcheListState;
  if (state is! DemarcheListSuccessState) throw Exception('Invalid state.');
  final demarche = state.demarches.where((e) => e.id == demarcheId).firstOrNull;
  if (demarche == null) throw Exception('No UserAction matching id $demarcheId');
  return demarche;
}
