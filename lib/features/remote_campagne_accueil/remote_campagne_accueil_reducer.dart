import 'package:pass_emploi_app/features/remote_campagne_accueil/remote_campagne_accueil_actions.dart';
import 'package:pass_emploi_app/features/remote_campagne_accueil/remote_campagne_accueil_state.dart';

RemoteCampagneAccueilState remoteCampagneAccueilReducer(RemoteCampagneAccueilState current, dynamic action) {
  if (action is RemoteCampagneAccueilSuccessAction) return RemoteCampagneAccueilState(campagnes: action.result);
  return current;
}
