import 'package:pass_emploi_app/models/location.dart';
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
    if (loginState.isSuccess()) {
      var userId = loginState.getResultOrThrow().id;
      if (action is SearchOffreEmploiAction) {
        _search(
          store: store,
          userId: userId,
          keyWords: action.keywords,
          location: action.location,
          pageToLoad: 1,
          filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
        );
      } else if (action is RequestMoreOffreEmploiSearchResultsAction &&
          parametersState is OffreEmploiSearchParametersInitializedState &&
          previousResultsState is OffreEmploiSearchResultsDataState) {
        _search(
          store: store,
          userId: userId,
          keyWords: parametersState.keyWords,
          location: parametersState.location,
          pageToLoad: previousResultsState.loadedPage + 1,
          filtres: parametersState.filtres,
        );
      } else if (action is OffreEmploiSearchUpdateFiltresAction &&
          parametersState is OffreEmploiSearchParametersInitializedState) {
        _resetSearchWithUpdatedFiltres(
          store: store,
          userId: userId,
          keyWords: parametersState.keyWords,
          location: parametersState.location,
          pageToLoad: 1,
          filtres: action.updatedFiltres,
        );
      }
    }
  }

  Future<void> _search({
    required Store<AppState> store,
    required String userId,
    required String keyWords,
    required Location? location,
    required int pageToLoad,
    required OffreEmploiSearchParametersFiltres filtres,
  }) async {
    store.dispatch(OffreEmploiSearchLoadingAction());
    final result = await _repository.search(
        userId: userId, keywords: keyWords, location: location, page: pageToLoad, filtres: filtres);
    if (result != null) {
      store.dispatch(OffreEmploiSearchSuccessAction(
        offres: result.offres,
        page: pageToLoad,
        isMoreDataAvailable: result.isMoreDataAvailable,
      ));
    } else {
      store.dispatch(OffreEmploiSearchFailureAction());
    }
  }

  Future<void> _resetSearchWithUpdatedFiltres({
    required Store<AppState> store,
    required String userId,
    required String keyWords,
    required Location? location,
    required int pageToLoad,
    required OffreEmploiSearchParametersFiltres filtres,
  }) async {
    store.dispatch(OffreEmploiSearchLoadingAction());
    final result = await _repository.search(
        userId: userId, keywords: keyWords, location: location, page: pageToLoad, filtres: filtres);
    if (result != null) {
      store.dispatch(OffreEmploiSearchWithUpdateFiltresSuccessAction(
        offres: result.offres,
        page: pageToLoad,
        isMoreDataAvailable: result.isMoreDataAvailable,
      ));
    } else {
      store.dispatch(OffreEmploiSearchWithUpdateFiltresFailureAction());
    }
  }
}
