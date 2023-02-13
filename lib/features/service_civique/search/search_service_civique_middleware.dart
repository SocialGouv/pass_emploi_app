import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/service_civique/search/search_service_civique_actions.dart';
import 'package:pass_emploi_app/features/service_civique/search/service_civique_search_result_state.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/models/service_civique/domain.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/service_civique_repository.dart';
import 'package:redux/redux.dart';

class SearchServiceCiviqueMiddleware extends MiddlewareClass<AppState> {
  final ServiceCiviqueRepository _repository;

  SearchServiceCiviqueMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState) {
      final ServiceCiviqueSearchResultState state = store.state.serviceCiviqueSearchResultState;
      if (action is RequestMoreServiceCiviqueSearchResultsAction) {
        if (state is ServiceCiviqueSearchResultDataState) {
          final request = SearchServiceCiviqueRequest(
            domain: state.lastRequest.domain,
            location: state.lastRequest.location,
            distance: state.lastRequest.distance,
            startDate: state.lastRequest.startDate,
            endDate: state.lastRequest.endDate,
            page: state.lastRequest.page + 1,
          );
          await _searchServiceCiviquePage(loginState, store, request, state.offres);
        }
      } else if (action is SearchServiceCiviqueAction) {
        final request = SearchServiceCiviqueRequest(
          domain: null,
          location: action.location,
          distance: null,
          startDate: null,
          endDate: null,
          page: 1,
        );
        await _searchServiceCiviquePage(loginState, store, request, []);
      } else if (action is ServiceCiviqueSavedSearchRequestAction) {
        final savedSearch = action.savedSearch;
        final request = SearchServiceCiviqueRequest(
          domain: savedSearch.domaine?.tag,
          location: savedSearch.location,
          distance: savedSearch.filtres.distance,
          startDate: null,
          // TODO - 1356 obsolete, à supprimer
          endDate: null,
          page: 1,
        );
        await _searchServiceCiviquePage(loginState, store, request, []);
      } else if (action is ServiceCiviqueSearchUpdateFiltresAction && state is ServiceCiviqueSearchResultDataState) {
        final request = SearchServiceCiviqueRequest(
          domain: (action.domain != Domaine.all) ? action.domain?.tag : null,
          location: state.lastRequest.location,
          distance: action.distance ?? state.lastRequest.distance,
          startDate: action.startDate?.toIso8601String(),
          endDate: null,
          page: 1,
        );
        await _searchServiceCiviquePage(loginState, store, request, []);
      } else if (action is RetryServiceCiviqueSearchAction && state is ServiceCiviqueSearchResultErrorState) {
        await _searchServiceCiviquePage(loginState, store, state.failedRequest, state.previousOffers);
      }
    }
  }

  Future<void> _searchServiceCiviquePage(
    LoginSuccessState loginState,
    Store<AppState> store,
    SearchServiceCiviqueRequest request,
    List<ServiceCivique> previousOffers,
  ) async {
    final ServiceCiviqueSearchResponse? response = await _repository.search(
      userId: loginState.user.id,
      request: request,
      previousOffers: previousOffers,
    );
    store.dispatch(response == null
        ? ServiceCiviqueSearchFailureAction(request, previousOffers)
        : ServiceCiviqueSearchSuccessAction(response));
  }
}
