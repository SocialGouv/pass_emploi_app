import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/parameters/offre_emploi_search_parameters_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/saved_search/offre_emploi_saved_search_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:redux/redux.dart';

class OffreEmploiMiddleware extends MiddlewareClass<AppState> {
  final OffreEmploiRepository _repository;

  OffreEmploiMiddleware(this._repository);

  @override
  call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState) {
      if (action is SavedOffreEmploiSearchRequestAction) {
        _resetSearchWithUpdatedFiltres(
          store: store,
          userId: loginState.user.id,
          request: SearchOffreEmploiRequest(
            keywords: action.keywords,
            location: action.location,
            onlyAlternance: action.onlyAlternance,
            page: 1,
            filtres: action.filtres,
          ),
        );
      }
    }
  }

  Future<void> _resetSearchWithUpdatedFiltres({
    required Store<AppState> store,
    required String userId,
    required SearchOffreEmploiRequest request,
  }) async {
    store.dispatch(OffreEmploiSearchLoadingAction());
    final result = await _repository.search(userId: userId, request: request);
    if (result != null) {
      store.dispatch(OffreEmploiSearchParametersUpdateFiltresSuccessAction(
        offres: result.offres,
        page: request.page,
        isMoreDataAvailable: result.isMoreDataAvailable,
      ));
    } else {
      store.dispatch(OffreEmploiSearchParametersUpdateFiltresFailureAction());
    }
  }
}
