import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_favoris_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_favoris_repository.dart';
import 'package:redux/redux.dart';

class OffreEmploiFavorisMiddleware extends MiddlewareClass<AppState> {
  final OffreEmploiFavorisRepository _repository;

  OffreEmploiFavorisMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    final offreEmploiResultsState = store.state.offreEmploiSearchResultsState;
    if (action is LoginAction && action.isSuccess()) {
      await _fetchFavorisId(action.getResultOrThrow().id, store);
    } else if (action is OffreEmploiRequestUpdateFavoriAction && loginState.isSuccess()) {
      if (action.newStatus && offreEmploiResultsState is OffreEmploiSearchResultsDataState) {
        await _addFavori(store, action, loginState.getResultOrThrow().id, offreEmploiResultsState);
      } else if (!action.newStatus) {
        await _removeFavori(store, action, loginState.getResultOrThrow().id);
      }
    } else if (action is RequestOffreEmploiFavorisAction && loginState.isSuccess()) {
      await _fetchFavoris(store, action, loginState.getResultOrThrow().id);
    }
  }

  Future<void> _fetchFavorisId(String userId, Store<AppState> store) async {
    final result = await _repository.getOffreEmploiFavorisId(userId);
    if (result != null) {
      store.dispatch(OffreEmploiFavorisIdLoadedAction(result));
    }
  }

  Future<void> _fetchFavoris(
    Store<AppState> store,
    RequestOffreEmploiFavorisAction action,
    String userId,
  ) async {
    final result = await _repository.getOffreEmploiFavoris(userId);
    if (result != null) {
      store.dispatch(OffreEmploiFavorisLoadedAction(result));
    } else {
      store.dispatch(OffreEmploiFavorisFailureAction());
    }
  }

  Future<void> _addFavori(
    Store<AppState> store,
    OffreEmploiRequestUpdateFavoriAction action,
    String userId,
    OffreEmploiSearchResultsDataState offreEmploiResultsState,
  ) async {
    store.dispatch(OffreEmploiUpdateFavoriLoadingAction(action.offreId));
    final result = await _repository.postFavori(
      userId,
      offreEmploiResultsState.offres.firstWhere((element) => element.id == action.offreId),
    );
    if (result) {
      store.dispatch(OffreEmploiUpdateFavoriSuccessAction(action.offreId, action.newStatus));
    } else {
      store.dispatch(OffreEmploiUpdateFavoriFailureAction(action.offreId));
    }
  }

  Future<void> _removeFavori(
    Store<AppState> store,
    OffreEmploiRequestUpdateFavoriAction action,
    String userId,
  ) async {
    store.dispatch(OffreEmploiUpdateFavoriLoadingAction(action.offreId));
    final result = await _repository.deleteFavori(userId, action.offreId);
    if (result) {
      store.dispatch(OffreEmploiUpdateFavoriSuccessAction(action.offreId, action.newStatus));
    } else {
      store.dispatch(OffreEmploiUpdateFavoriFailureAction(action.offreId));
    }
  }
}
