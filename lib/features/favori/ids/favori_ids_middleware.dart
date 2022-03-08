import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/favoris/favoris_repository.dart';
import 'package:redux/redux.dart';

import 'favori_ids_action.dart';

class FavoriIdsMiddleware<T> extends MiddlewareClass<AppState> {
  final FavorisRepository<T> _repository;

  FavoriIdsMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is LoginSuccessAction) {
      final ids = await _repository.getFavorisId(action.user.id);
      if (ids != null) store.dispatch(FavoriIdsLoadedAction<T>(ids));
    }
  }
}
