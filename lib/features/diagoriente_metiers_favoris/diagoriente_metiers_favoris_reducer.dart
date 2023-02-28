import 'package:pass_emploi_app/features/diagoriente_metiers_favoris/diagoriente_metiers_favoris_actions.dart';
import 'package:pass_emploi_app/features/diagoriente_metiers_favoris/diagoriente_metiers_favoris_state.dart';

DiagorienteMetiersFavorisState diagorienteMetiersFavorisReducer(
    DiagorienteMetiersFavorisState current, dynamic action) {
  if (action is DiagorienteMetiersFavorisLoadingAction) return DiagorienteMetiersFavorisLoadingState();
  if (action is DiagorienteMetiersFavorisFailureAction) return DiagorienteMetiersFavorisFailureState();
  if (action is DiagorienteMetiersFavorisSuccessAction) {
    return DiagorienteMetiersFavorisSuccessState(action.aDesMetiersFavoris);
  }
  if (action is DiagorienteMetiersFavorisResetAction) return DiagorienteMetiersFavorisNotInitializedState();
  return current;
}
