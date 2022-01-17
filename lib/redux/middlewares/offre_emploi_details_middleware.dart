import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_details_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/favoris_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_details_repository.dart';
import 'package:redux/redux.dart';

class OffreEmploiDetailsMiddleware extends MiddlewareClass<AppState> {
  final OffreEmploiDetailsRepository _repository;

  OffreEmploiDetailsMiddleware(this._repository);

  @override
  call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);
    if (action is OffreEmploiDetailsAction && action.isRequest()) {
      final offreId = action.getRequestOrThrow();
      store.dispatch(OffreEmploiDetailsAction.loading());
      final result = await _repository.getOffreEmploiDetails(offreId: offreId);
      if (result.offreEmploiDetails != null) {
        store.dispatch(OffreEmploiDetailsAction.success(result.offreEmploiDetails!));
      } else {
        _dispatchIncompleteDataOrError(store, result, offreId);
      }
    }
  }

  void _dispatchIncompleteDataOrError(Store<AppState> store, OffreEmploiDetailsResponse result, String offreId) {
    var favorisState = store.state.offreEmploiFavorisState;
    if (result.isOffreNotFound &&
        favorisState is FavorisLoadedState<OffreEmploi> &&
        favorisState.data != null &&
        favorisState.data![offreId] != null) {
      store.dispatch(OffreEmploiDetailsIncompleteDataAction(favorisState.data![offreId]!));
    } else {
      store.dispatch(OffreEmploiDetailsAction.failure());
    }
  }
}
