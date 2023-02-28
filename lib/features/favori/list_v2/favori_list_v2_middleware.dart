import 'package:pass_emploi_app/features/favori/list_v2/favori_list_v2_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/favoris/get_favoris_repository.dart';
import 'package:redux/redux.dart';

class FavoriListV2Middleware extends MiddlewareClass<AppState> {
  final GetFavorisRepository _repository;

  FavoriListV2Middleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId != null && action is FavoriListV2RequestAction) {
      final result = await _repository.getFavoris(userId);
      store.dispatch(result != null ? FavoriListV2SuccessAction(result) : FavoriListV2FailureAction());
    }
  }
}
