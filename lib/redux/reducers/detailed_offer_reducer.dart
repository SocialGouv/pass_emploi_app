import 'package:pass_emploi_app/redux/actions/detailed_offer_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/detailed_offer_state.dart';

AppState detailedOfferReducer(AppState currentState, dynamic action) {
  if (action is DetailedOfferLoadingAction) {
    return currentState.copyWith(detailedOfferState: DetailedOfferState.loading());
  } else if (action is DetailedOfferSuccessAction) {
    return currentState.copyWith(detailedOfferState: DetailedOfferState.success(action.offer));
  } else if (action is DetailedOfferFailureAction) {
    return currentState.copyWith(detailedOfferState: DetailedOfferState.failure());
  } else {
    return currentState;
  }
}