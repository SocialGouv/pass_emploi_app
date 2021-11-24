import 'package:pass_emploi_app/redux/actions/offre_emploi_details_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_details_state.dart';

AppState offreEmploiDetailsReducer(AppState currentState, dynamic action) {
  if (action is OffreEmploiDetailsLoadingAction) {
    return currentState.copyWith(offreEmploiDetailsState: OffreEmploiDetailsState.loading());
  } else if (action is OffreEmploiDetailsSuccessAction) {
    return currentState.copyWith(offreEmploiDetailsState: OffreEmploiDetailsState.success(action.offre));
  } else if (action is OffreEmploiDetailsFailureAction) {
    return currentState.copyWith(offreEmploiDetailsState: OffreEmploiDetailsState.failure());
  } else {
    return currentState;
  }
}