import 'package:pass_emploi_app/features/location/search_location_actions.dart';
import 'package:pass_emploi_app/features/location/search_location_state.dart';

SearchLocationState searchLocationReducer(SearchLocationState current, dynamic action) {
  if (action is SearchLocationsSuccessAction) return SearchLocationState(action.locations);
  if (action is SearchLocationResetAction) return SearchLocationState([]);
  return current;
}
