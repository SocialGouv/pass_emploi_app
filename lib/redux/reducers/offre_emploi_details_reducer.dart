import 'package:pass_emploi_app/redux/actions/offre_emploi_details_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/detailed_offer_state.dart';

AppState offreEmploiDetailsReducer(AppState currentState, dynamic action) {
  if (action is OffreEmploiDetailsLoadingAction) {
    return currentState.copyWith(detailedOfferState: DetailedOfferState.loading());
  } else if (action is OffreEmploiDetailsSuccessAction) {
    return currentState.copyWith(detailedOfferState: DetailedOfferState.success(action.offre));
  } else if (action is OffreEmploiDetailsFailureAction) {
    return currentState.copyWith(detailedOfferState: DetailedOfferState.failure());
  } else {
    return currentState;
  }
}