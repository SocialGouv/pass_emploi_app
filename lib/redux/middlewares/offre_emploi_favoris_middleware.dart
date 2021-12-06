import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_favoris_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
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
    if (action is LoggedInAction) {
      await _fetchFavorisId(action, store);
    } else if (action is OffreEmploiRequestUpdateFavoriAction &&
        loginState is LoggedInState &&
        offreEmploiResultsState is OffreEmploiSearchResultsDataState) {
      await _updateFavori(store, action, loginState, offreEmploiResultsState);
    } else if (action is RequestOffreEmploiFavorisAction && loginState is LoggedInState) {
      await _fetchFavoris(store, action, loginState);
    }
  }

  Future<void> _fetchFavorisId(LoggedInAction action, Store<AppState> store) async {
    final result = await _repository.getOffreEmploiFavorisId(action.user.id);
    if (result != null) {
      store.dispatch(OffreEmploisFavorisIdLoadedAction(result));
    }
  }

  Future<void> _fetchFavoris(
    Store<AppState> store,
    RequestOffreEmploiFavorisAction action,
    LoggedInState loginState,
  ) async {
    final result = await _repository.getOffreEmploiFavoris(loginState.user.id);
    if (result != null) {
      store.dispatch(OffreEmploisFavorisLoadedAction(result));
    }
  }

  Future<void> _updateFavori(
    Store<AppState> store,
    OffreEmploiRequestUpdateFavoriAction action,
    LoggedInState loginState,
    OffreEmploiSearchResultsDataState offreEmploiResultsState,
  ) async {
    store.dispatch(OffreEmploiUpdateFavoriLoadingAction(action.offreId));
    final result = await _repository.updateOffreEmploiFavoriStatus(
      loginState.user.id,
      offreEmploiResultsState.offres.firstWhere((element) => element.id == action.offreId),
      action.newStatus,
    );
    if (result) {
      store.dispatch(OffreEmploiUpdateFavoriSuccessAction(action.offreId, action.newStatus));
    } else {
      store.dispatch(OffreEmploiUpdateFavoriFailureAction(action.offreId));
    }
  }

}
