import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/redux/actions/search_service_civique_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';

import 'package:redux/redux.dart';

import '../../repositories/service_civique_repository.dart';
import '../actions/search_location_action.dart';

class SearchServiceCiviqueMiddleware extends MiddlewareClass<AppState> {
  final ServiceCiviqueRepository _repository;

  SearchServiceCiviqueMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is SearchServiceCiviqueAction) {
      final List<Location> locations = [];
      final input = action.input;
      if (input != null && input.length > 1) {
        final loginState = store.state.loginState;
        if (loginState.isSuccess()) {
          locations.addAll(await _repository.getLocations(
            userId: loginState.getResultOrThrow().id,
            query: input,
            villesOnly: action.villesOnly,
          ));
        }
      }
      store.dispatch(SearchLocationsSuccessAction(locations));
    }
  }
}
