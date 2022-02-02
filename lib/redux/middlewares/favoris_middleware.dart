import 'package:pass_emploi_app/redux/actions/favoris_action.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/favoris_repository.dart';
import 'package:redux/redux.dart';

class FavorisMiddleware<T> extends MiddlewareClass<AppState> {
  final FavorisRepository<T> _repository;
  final DataFromIdExtractor<T> _dataFromIdExtractor;

  FavorisMiddleware(this._repository, this._dataFromIdExtractor);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is LoginAction && action.isSuccess()) {
      await _fetchFavorisId(action.getResultOrThrow().id, store);
    } else if (action is RequestUpdateFavoriAction<T> && loginState.isSuccess()) {
      if (action.newStatus) {
        await _addFavori(store, action, loginState.getResultOrThrow().id);
      } else {
        await _removeFavori(store, action, loginState.getResultOrThrow().id);
      }
    } else if (action is RequestFavorisAction<T> && loginState.isSuccess()) {
      await _fetchFavoris(store, action, loginState.getResultOrThrow().id);
    }
  }

  Future<void> _fetchFavorisId(String userId, Store<AppState> store) async {
    final result = await _repository.getFavorisId(userId);
    if (result != null) {
      store.dispatch(FavorisIdLoadedAction<T>(result));
    }
  }

  Future<void> _fetchFavoris(
    Store<AppState> store,
    RequestFavorisAction<T> action,
    String userId,
  ) async {
    final result = await _repository.getFavoris(userId);
    if (result != null) {
      store.dispatch(FavorisLoadedAction<T>(result));
    } else {
      store.dispatch(FavorisFailureAction<T>());
    }
  }

  Future<void> _addFavori(
    Store<AppState> store,
    RequestUpdateFavoriAction<T> action,
    String userId,
  ) async {
    store.dispatch(UpdateFavoriLoadingAction<T>(action.favoriId));
    final result = await _repository.postFavori(
      userId,
      _dataFromIdExtractor.extractFromId(store, action.favoriId),
    );
    if (result) {
      store.dispatch(UpdateFavoriSuccessAction<T>(action.favoriId, action.newStatus));
    } else {
      store.dispatch(UpdateFavoriFailureAction<T>(action.favoriId));
    }
  }

  Future<void> _removeFavori(
    Store<AppState> store,
    RequestUpdateFavoriAction<T> action,
    String userId,
  ) async {
    store.dispatch(UpdateFavoriLoadingAction<T>(action.favoriId));
    final result = await _repository.deleteFavori(userId, action.favoriId);
    if (result) {
      store.dispatch(UpdateFavoriSuccessAction<T>(action.favoriId, action.newStatus));
    } else {
      store.dispatch(UpdateFavoriFailureAction<T>(action.favoriId));
    }
  }
}

abstract class DataFromIdExtractor<T> {
  T extractFromId(Store<AppState> store, String favoriId);
}
