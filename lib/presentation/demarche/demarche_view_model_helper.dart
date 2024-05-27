import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

Demarche getDemarche(Store<AppState> store, DemarcheStateSource stateSource, String demarcheId) {
  return switch (stateSource) {
    DemarcheStateSource.monSuivi => _getFromMonSuiviState(store, demarcheId),
  };
}

Demarche _getFromMonSuiviState(Store<AppState> store, String demarcheId) {
  final state = store.state.monSuiviState;
  if (state is! MonSuiviSuccessState) throw Exception('Invalid state.');
  final demarche = state.monSuivi.demarches.where((e) => e.id == demarcheId).firstOrNull;
  if (demarche == null) throw Exception('No demarche matching id $demarcheId');
  return demarche;
}