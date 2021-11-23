import 'package:pass_emploi_app/models/detailed_offer.dart';
import 'package:pass_emploi_app/redux/actions/detailed_offer_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/detailed_offer_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';


enum OffreEmploiListDisplayState { SHOW_DETAILS, SHOW_LOADER, SHOW_ERROR, NOT_INIT }

class OffreEmploiListViewModel {
  final Function(String offerId) getDetailsRequest;
  final OffreEmploiListDisplayState displayState;
  final DetailedOffer? detailedOffer;
  final String errorMessage;


  OffreEmploiListViewModel._({
    required this.getDetailsRequest,
    required this.displayState,
    required this.detailedOffer,
    required this.errorMessage
  });

  factory OffreEmploiListViewModel.getDetails(Store<AppState> store) {
    final searchState = store.state.detailedOfferState;
    return OffreEmploiListViewModel._(
      getDetailsRequest: (id) => _getDetailsRequest(store, id),
      displayState: _displayState(searchState),
      detailedOffer: _detailedOffer(searchState),
      errorMessage:  Strings.genericError,
    );
  }
}

void _getDetailsRequest(Store<AppState> store, String offerId,) {
  store.dispatch(GetDetailedOfferAction(offerId: offerId));
}

OffreEmploiListDisplayState _displayState(DetailedOfferState searchState) {
  if (searchState is DetailedOfferSuccessState) {
    return OffreEmploiListDisplayState.SHOW_DETAILS;
  } else if (searchState is DetailedOfferLoadingState) {
    return OffreEmploiListDisplayState.SHOW_LOADER;
  } else if (searchState is DetailedOfferFailureState) {
    return OffreEmploiListDisplayState.SHOW_ERROR;
  } else
    return OffreEmploiListDisplayState.NOT_INIT;
}

DetailedOffer? _detailedOffer(DetailedOfferState searchState) {
  return searchState is DetailedOfferSuccessState
      ? searchState.offer : null;
}