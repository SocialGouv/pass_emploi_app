import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

extension DemarcheStoreExtension on Store<AppState> {
  Demarche getDemarche(String demarcheId) {
    final monSuiviState = state.monSuiviState;
    if (monSuiviState is! MonSuiviSuccessState) throw Exception('Invalid state.');
    final demarche = monSuiviState.monSuivi.demarches.where((e) => e.id == demarcheId).firstOrNull;
    if (demarche == null) throw Exception('No demarche matching id $demarcheId');
    return demarche;
  }

  Demarche? getDemarcheOrNull(String demarcheId) {
    try {
      return getDemarche(demarcheId);
    } catch (e) {
      return null;
    }
  }
}
