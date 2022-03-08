import 'package:pass_emploi_app/features/location/search_location_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/search_location_repository.dart';
import 'package:redux/redux.dart';

class SearchLocationMiddleware extends MiddlewareClass<AppState> {
  final SearchLocationRepository _repository;

  SearchLocationMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is SearchLocationRequestAction) {
      final List<Location> locations = [];
      final input = action.input;
      if (input != null && input.length > 1) {
        final loginState = store.state.loginState;
        if (loginState is LoginSuccessState) {
          locations.addAll(await _repository.getLocations(
            userId: loginState.user.id,
            query: input,
            villesOnly: action.villesOnly,
          ));
        }
      }
      store.dispatch(SearchLocationsSuccessAction(locations));
    }
  }
}
