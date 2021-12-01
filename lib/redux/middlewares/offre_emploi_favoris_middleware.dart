import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_favoris_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_favoris_repository.dart';
import 'package:redux/redux.dart';

class OffreEmploiFavorisMiddleware extends MiddlewareClass<AppState> {
  final OffreEmploiFavorisRepository _repository;

  OffreEmploiFavorisMiddleware(this._repository);

  @override
  call(Store<dynamic> store, action, NextDispatcher next) async {
    next(action);
    if (action is LoggedInAction) {
      final result = await _repository.getOffreEmploiFavorisId(action.user.id);
      if (result != null) {
        store.dispatch(OffreEmploisFavorisIdLoadedAction(result));
      }
    }
  }
}
