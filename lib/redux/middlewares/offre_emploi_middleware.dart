import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_state.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:redux/redux.dart';

class OffreEmploiMiddleware extends MiddlewareClass<AppState> {
  final OffreEmploiRepository _repository;

  OffreEmploiMiddleware(this._repository);

  @override
  call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    final parametersState = store.state.offreEmploiSearchParametersState;
    final previousResultsState = store.state.offreEmploiSearchResultsState;
    final offreEmploiSearchState = store.state.offreEmploiSearchState;
    if (loginState is LoginSuccessState) {
      var userId = loginState.user.id;
      if (action is OffreEmploiSearchRequestAction) {
        _search(
          store: store,
          userId: userId,
          request: SearchOffreEmploiRequest(
            keywords: action.keywords,
            location: action.location,
            onlyAlternance: action.onlyAlternance,
            page: 1,
            filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
          ),
        );
      } else if (action is OffreEmploiSearchRequestMoreResultsAction &&
          parametersState is OffreEmploiSearchParametersInitializedState &&
          previousResultsState is OffreEmploiSearchResultsDataState &&
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
      } else if (action is OffreEmploiSearchUpdateFiltresAction &&
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
      } else if (action is OffreEmploiSearchWithFiltresAction) {
        _resetSearchWithUpdatedFiltres(
          store: store,
          userId: userId,
          request: SearchOffreEmploiRequest(
            keywords: action.keywords,
            location: action.location,
            onlyAlternance: action.onlyAlternance,
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
      store.dispatch(OffreEmploiSearchWithUpdateFiltresSuccessAction(
        offres: result.offres,
        page: request.page,
        isMoreDataAvailable: result.isMoreDataAvailable,
      ));
    } else {
      store.dispatch(OffreEmploiSearchWithUpdateFiltresFailureAction());
    }
  }
}
