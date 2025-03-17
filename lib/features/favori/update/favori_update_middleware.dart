import 'package:pass_emploi_app/features/favori/update/favori_update_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/favoris/favoris_repository.dart';
import 'package:redux/redux.dart';

class FavoriUpdateMiddleware<T> extends MiddlewareClass<AppState> {
  final FavorisRepository<T> _repository;
  final DataFromIdExtractor<T> _dataFromIdExtractor;

  FavoriUpdateMiddleware(this._repository, this._dataFromIdExtractor);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is FavoriUpdateRequestAction<T> && loginState is LoginSuccessState) {
      if (action.newStatus == FavoriStatus.added) await _addFavori(store, action, loginState.user.id);
      if (action.newStatus == FavoriStatus.postulated) _addFavori(store, action, loginState.user.id, postulated: true);
      if (action.newStatus == FavoriStatus.removed) await _removeFavori(store, action, loginState.user.id);
    }
  }

  Future<void> _addFavori(
    Store<AppState> store,
    FavoriUpdateRequestAction<T> action,
    String userId, {
    bool postulated = false,
  }) async {
    store.dispatch(FavoriUpdateLoadingAction<T>(action.favoriId));
    final result = await _repository.postFavori(
      userId,
      _dataFromIdExtractor.extractFromId(store, action.favoriId),
      postulated: postulated,
    );
    if (result) {
      store.dispatch(FavoriUpdateSuccessAction<T>(action.favoriId, action.newStatus));
    } else {
      store.dispatch(FavoriUpdateFailureAction<T>(action.favoriId));
    }
  }

  Future<void> _removeFavori(
    Store<AppState> store,
    FavoriUpdateRequestAction<T> action,
    String userId,
  ) async {
    store.dispatch(FavoriUpdateLoadingAction<T>(action.favoriId));
    final result = await _repository.deleteFavori(userId, action.favoriId);
    if (result) {
      store.dispatch(FavoriUpdateSuccessAction<T>(action.favoriId, action.newStatus));
    } else {
      store.dispatch(FavoriUpdateFailureAction<T>(action.favoriId));
    }
  }
}

abstract class DataFromIdExtractor<T> {
  T extractFromId(Store<AppState> store, String favoriId);
}
