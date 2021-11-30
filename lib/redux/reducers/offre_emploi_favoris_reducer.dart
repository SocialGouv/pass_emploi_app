import 'package:pass_emploi_app/redux/actions/offre_emploi_favoris_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_state.dart';

AppState offreEmploiFavorisReducer(AppState currentState, dynamic action) {
  if (action is OffreEmploisFavorisIdLoadedAction) {
    return currentState.copyWith(offreEmploiFavorisState: OffreEmploiFavorisIdState.idsLoaded(action.favorisId));
  } else {
    return currentState;
  }
}
