import 'package:pass_emploi_app/features/favori/list/favori_list_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/favoris/favoris_repository.dart';
import 'package:redux/redux.dart';

class FavoriListMiddleware<T> extends MiddlewareClass<AppState> {
  final FavorisRepository<T> _repository;

  FavoriListMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is FavoriListRequestAction<T> && loginState is LoginSuccessState) {
      final favoris = await _repository.getFavoris(loginState.user.id);
      store.dispatch(favoris != null ? FavoriListLoadedAction<T>(favoris) : FavoriListFailureAction<T>());
    }
  }
}
