import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/list/offre_emploi_list_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/parameters/offre_emploi_search_parameters_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/parameters/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_state.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:redux/redux.dart';

class OffreEmploiMiddleware extends MiddlewareClass<AppState> {
  final OffreEmploiRepository _repository;

  OffreEmploiMiddleware(this._repository);

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    final parametersState = store.state.offreEmploiSearchParametersState;
    final previousResultsState = store.state.offreEmploiListState;
    final offreEmploiSearchState = store.state.offreEmploiSearchState;
    if (loginState is LoginSuccessState) {
      final userId = loginState.user.id;
      if (action is OffreEmploiSearchRequestAction) {
        _search(
          store: store,
          userId: userId,
          request: SearchOffreEmploiRequest(
            keywords: action.keywords,
            location: action.location,
            onlyAlternance: action.onlyAlternance,
            page: 1,
            filtres: EmploiFiltresRecherche.noFiltre(),
          ),
        );
      } else if (action is OffreEmploiSearchRequestMoreResultsAction &&
          parametersState is OffreEmploiSearchParametersInitializedState &&
          previousResultsState is OffreEmploiListSuccessState &&
          offreEmploiSearchState is! OffreEmploiSearchLoadingState) {
        _search(
          store: store,
          userId: userId,
          request: SearchOffreEmploiRequest(
            keywords: parametersState.keywords,
            location: parametersState.location,
            onlyAlternance: parametersState.onlyAlternance,
            page: previousResultsState.loadedPage + 1,
            filtres: parametersState.filtres,
          ),
        );
      } else if (action is OffreEmploiSearchParametersUpdateFiltresRequestAction &&
          parametersState is OffreEmploiSearchParametersInitializedState) {
        _resetSearchWithUpdatedFiltres(
          store: store,
          userId: userId,
          request: SearchOffreEmploiRequest(
            keywords: parametersState.keywords,
            location: parametersState.location,
            onlyAlternance: parametersState.onlyAlternance,
            page: 1,
            filtres: action.updatedFiltres,
          ),
        );
      }
    }
  }

  Future<void> _search({
    required Store<AppState> store,
    required String userId,
    required SearchOffreEmploiRequest request,
  }) async {
    store.dispatch(OffreEmploiSearchLoadingAction());
    final result = await _repository.search(userId: userId, request: request);
    if (result != null) {
      store.dispatch(OffreEmploiSearchSuccessAction(
        offres: result.offres,
        page: request.page,
        isMoreDataAvailable: result.isMoreDataAvailable,
      ));
    } else {
      store.dispatch(OffreEmploiSearchFailureAction());
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
