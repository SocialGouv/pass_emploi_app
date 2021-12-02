import 'package:pass_emploi_app/redux/actions/offre_emploi_favoris_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_id_state.dart';

AppState offreEmploiFavorisReducer(AppState currentState, dynamic action) {
  if (action is OffreEmploisFavorisIdLoadedAction) {
    return currentState.copyWith(offreEmploiFavorisIdState: OffreEmploiFavorisIdState.idsLoaded(action.favorisId));
  } else {
    return currentState;
  }
}
