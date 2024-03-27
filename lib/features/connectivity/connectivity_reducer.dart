import 'package:pass_emploi_app/features/connectivity/connectivity_actions.dart';
import 'package:pass_emploi_app/features/connectivity/connectivity_state.dart';

ConnectivityState connectivityReducer(ConnectivityState current, dynamic action) {
  if (action is ConnectivityUpdatedAction) return ConnectivityState.fromResults(action.results);
  return current;
}
