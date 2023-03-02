import 'package:pass_emploi_app/features/favori/list/favori_list_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/favoris/get_favoris_repository.dart';
import 'package:redux/redux.dart';

class FavoriListMiddleware extends MiddlewareClass<AppState> {
  final GetFavorisRepository _repository;

  FavoriListMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId != null && action is FavoriListRequestAction) {
      final result = await _repository.getFavoris(userId);
      store.dispatch(result != null ? FavoriListSuccessAction(result) : FavoriListFailureAction());
    }
  }
}
