import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/redux/actions/favoris_action.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
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
    } else if (action is RequestUpdateFavoriAction<OffreEmploi> && loginState.isSuccess()) {
      if (action.newStatus && offreEmploiResultsState is OffreEmploiSearchResultsDataState) {
        await _addFavori(store, action, loginState.getResultOrThrow().id, offreEmploiResultsState);
      } else if (!action.newStatus) {
        await _removeFavori(store, action, loginState.getResultOrThrow().id);
      }
    } else if (action is RequestFavorisAction<OffreEmploi> && loginState.isSuccess()) {
      await _fetchFavoris(store, action, loginState.getResultOrThrow().id);
    }
  }

  Future<void> _fetchFavorisId(String userId, Store<AppState> store) async {
    final result = await _repository.getOffreEmploiFavorisId(userId);
    if (result != null) {
      store.dispatch(FavorisIdLoadedAction<OffreEmploi>(result));
    }
  }

  Future<void> _fetchFavoris(
    Store<AppState> store,
    RequestFavorisAction<OffreEmploi> action,
    String userId,
  ) async {
    final result = await _repository.getOffreEmploiFavoris(userId);
    if (result != null) {
      store.dispatch(FavorisLoadedAction<OffreEmploi>(result));
    } else {
      store.dispatch(FavorisFailureAction<OffreEmploi>());
    }
  }

  Future<void> _addFavori(
    Store<AppState> store,
    RequestUpdateFavoriAction<OffreEmploi> action,
    String userId,
    OffreEmploiSearchResultsDataState offreEmploiResultsState,
  ) async {
    store.dispatch(UpdateFavoriLoadingAction<OffreEmploi>(action.favoriId));
    final result = await _repository.postFavori(
      userId,
      offreEmploiResultsState.offres.firstWhere((element) => element.id == action.favoriId),
    );
    if (result) {
      store.dispatch(UpdateFavoriSuccessAction<OffreEmploi>(action.favoriId, action.newStatus));
    } else {
      store.dispatch(UpdateFavoriFailureAction<OffreEmploi>(action.favoriId));
    }
  }

  Future<void> _removeFavori(
    Store<AppState> store,
    RequestUpdateFavoriAction<OffreEmploi> action,
    String userId,
  ) async {
    store.dispatch(UpdateFavoriLoadingAction<OffreEmploi>(action.favoriId));
    final result = await _repository.deleteFavori(userId, action.favoriId);
    if (result) {
      store.dispatch(UpdateFavoriSuccessAction<OffreEmploi>(action.favoriId, action.newStatus));
    } else {
      store.dispatch(UpdateFavoriFailureAction<OffreEmploi>(action.favoriId));
    }
  }
}
