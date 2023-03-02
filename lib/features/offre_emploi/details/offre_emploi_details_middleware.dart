import 'package:pass_emploi_app/features/favori/list_v2/favori_list_v2_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_actions.dart';
import 'package:pass_emploi_app/models/favori.dart';
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
    final favorisState = store.state.favoriListV2State;
    if (result.isOffreNotFound &&
        favorisState is FavoriListV2SuccessState &&
        favorisState.results.any((element) => element.id == offreId)) {
      final favori = favorisState.results.firstWhere((element) => element.id == offreId);
      store.dispatch(OffreEmploiDetailsIncompleteDataAction(favori.toOffreEmploi));
    } else {
      store.dispatch(OffreEmploiDetailsFailureAction());
    }
  }
}
