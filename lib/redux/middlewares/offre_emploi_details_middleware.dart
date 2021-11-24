import 'package:pass_emploi_app/redux/actions/offre_emploi_details_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/detailed_offer_repository.dart';
import 'package:redux/redux.dart';

class OffreEmploiDetailsMiddleware extends MiddlewareClass<AppState> {
  final DetailedOfferRepository _repository;

  OffreEmploiDetailsMiddleware(this._repository);

  @override
  call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);
    if (action is GetOffreEmploiDetailsAction) {
      store.dispatch(OffreEmploiDetailsLoadingAction());
      final result = await _repository.getDetailedOffer(offerId: action.offreId);
      if (result != null) {
        store.dispatch(OffreEmploiDetailsSuccessAction(result));
      } else {
        store.dispatch(OffreEmploiDetailsFailureAction());
      }
    }
  }
}
