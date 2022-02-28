import 'package:pass_emploi_app/features/service_civique/search/search_service_civique_actions.dart';
import 'package:pass_emploi_app/features/service_civique/search/service_civique_search_result_state.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:redux/redux.dart';

import '../../../models/service_civique.dart';
import '../../../repositories/service_civique_repository.dart';

class SearchServiceCiviqueMiddleware extends MiddlewareClass<AppState> {
  final ServiceCiviqueRepository _repository;

  SearchServiceCiviqueMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is RequestMoreServiceCiviqueSearchResultsAction) {
      final loginState = store.state.loginState;
      if (loginState.isSuccess()) {
        final ServiceCiviqueSearchResultState state = store.state.serviceCiviqueSearchResultState;
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
      }
    }
    if (action is SearchServiceCiviqueAction) {
      final loginState = store.state.loginState;
      if (loginState.isSuccess()) {
        final request = SearchServiceCiviqueRequest(
          domain: null,
          location: action.location,
          distance: null,
          startDate: null,
          endDate: null,
          page: 0,
        );
        await _searchServiceCiviquePage(loginState, store, request, []);
      }
    }
  }

  Future<void> _searchServiceCiviquePage(
    State<User> loginState,
    Store<AppState> store,
    SearchServiceCiviqueRequest request,
    List<ServiceCivique> previousOffers,
  ) async {
    final ServiceCiviqueSearchResponse? response = await _repository.search(
      userId: loginState.getResultOrThrow().id,
      request: request,
      previousOffers: previousOffers,
    );
    store
        .dispatch(response == null ? ServiceCiviqueSearchFailureAction() : ServiceCiviqueSearchSuccessAction(response));
  }
}
