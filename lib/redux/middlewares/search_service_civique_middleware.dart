import 'package:pass_emploi_app/redux/actions/search_service_civique_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

import '../../repositories/service_civique_repository.dart';

class SearchServiceCiviqueMiddleware extends MiddlewareClass<AppState> {
  final ServiceCiviqueRepository _repository;

  SearchServiceCiviqueMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is SearchServiceCiviqueAction) {
      final loginState = store.state.loginState;
      if (loginState.isSuccess()) {
        final ServiceCiviqueSearchResponse? response = await _repository.search(
          userId: loginState.getResultOrThrow().id,
          request: SearchServiceCiviqueRequest(
            domain: null,
            location: action.location,
            distance: null,
            startDate: null,
            endDate: null,
            page: 0,
          ),
        );
        store.dispatch(response == null ? ServiceCiviqueFailureAction() : ServiceCiviqueSuccessAction(response));
      }
    }
  }
}
