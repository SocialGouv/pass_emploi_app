import 'package:pass_emploi_app/features/recherches_derniers_mots_cles/recherches_derniers_mots_cles_actions.dart';
import 'package:pass_emploi_app/features/recherches_derniers_mots_cles/recherches_derniers_mots_cles_state.dart';

RecherchesDerniersMotsClesState recherchesDerniersMotsClesReducer(
    RecherchesDerniersMotsClesState current, dynamic action) {
  if (action is RecherchesDerniersMotsClesSuccessAction) {
    return RecherchesDerniersMotsClesState(motsCles: action.motsCles);
  }
  return current;
}
