import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_favoris_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_favoris_repository.dart';
import 'package:redux/redux.dart';

class OffreEmploiFavorisMiddleware extends MiddlewareClass<AppState> {
  final OffreEmploiFavorisRepository _repository;

  OffreEmploiFavorisMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is LoggedInAction) {
      final result = await _repository.getOffreEmploiFavorisId(action.user.id);
      if (result != null) {
        store.dispatch(OffreEmploisFavorisIdLoadedAction(result));
      }
    } else if (action is OffreEmploiRequestUpdateFavoriAction && loginState is LoggedInState) {
      store.dispatch(OffreEmploiUpdateFavoriLoadingAction(action.offreId));
      final result = await _repository.updateOffreEmploiFavoriStatus(
        loginState.user.id,
        action.offreId,
        action.newStatus,
      );
      if (result) {
        store.dispatch(OffreEmploiUpdateFavoriSuccessAction(action.offreId, action.newStatus));
      } else {
        store.dispatch(OffreEmploiUpdateFavoriFailureAction(action.offreId));
      }
    }
  }
}
