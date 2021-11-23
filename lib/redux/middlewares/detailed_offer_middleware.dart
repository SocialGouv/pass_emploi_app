import 'package:pass_emploi_app/redux/actions/detailed_offer_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/detailed_offer_repository.dart';
import 'package:redux/redux.dart';

class DetailedOfferMiddleware extends MiddlewareClass<AppState> {
  final DetailedOfferRepository _repository;

  DetailedOfferMiddleware(this._repository);

  @override
  call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);
    if (action is GetDetailedOfferAction) {
      store.dispatch(DetailedOfferLoadingAction());
      final result = await _repository.getDetailedOffer(offerId: action.offerId);
      if (result != null) {
        store.dispatch(DetailedOfferSuccessAction(result));
      } else {
        store.dispatch(DetailedOfferFailureAction());
      }
    }
  }
}
