import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_actions.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_details_repository.dart';
import 'package:redux/redux.dart';

class OffreEmploiDetailsMiddleware extends MiddlewareClass<AppState> {
  final OffreEmploiDetailsRepository _repository;

  OffreEmploiDetailsMiddleware(this._repository);

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);
    if (action is OffreEmploiDetailsRequestAction) {
      store.dispatch(OffreEmploiDetailsLoadingAction());
      final result = await _repository.getOffreEmploiDetails(offreId: action.offreId);
      if (result.details != null) {
        store.dispatch(OffreEmploiDetailsSuccessAction(result.details!));
      } else {
        _dispatchIncompleteDataOrError(store, result, action.offreId);
      }
    }
  }

  void _dispatchIncompleteDataOrError<T>(Store<AppState> store, OffreDetailsResponse<T> result, String offreId) {
    final favorisState = store.state.offreEmploiFavorisState;
    if (result.isOffreNotFound &&
        favorisState is FavoriListLoadedState<OffreEmploi> &&
        favorisState.data != null &&
        favorisState.data![offreId] != null) {
      store.dispatch(OffreEmploiDetailsIncompleteDataAction(favorisState.data![offreId]!));
    } else {
      store.dispatch(OffreEmploiDetailsFailureAction());
    }
  }
}
