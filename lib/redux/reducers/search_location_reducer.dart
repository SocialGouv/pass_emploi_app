import 'package:pass_emploi_app/redux/actions/search_location_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/search_location_state.dart';

AppState searchLocationReducer(AppState currentState, SearchLocationAction action) {
  if (action is SearchLocationsSuccessAction) {
    return currentState.copyWith(searchLocationState: SearchLocationState(action.locations));
  } else if (action is ResetLocationAction) {
    return currentState.copyWith(searchLocationState: SearchLocationState([]));
  } else {
    return currentState;
  }
}
