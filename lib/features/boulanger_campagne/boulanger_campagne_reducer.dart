import 'package:pass_emploi_app/features/boulanger_campagne/boulanger_campagne_actions.dart';
import 'package:pass_emploi_app/features/boulanger_campagne/boulanger_campagne_state.dart';

BoulangerCampagneState boulangerCampagneReducer(BoulangerCampagneState current, dynamic action) {
  if (action is BoulangerCampagneSuccessAction) return BoulangerCampagneState(result: action.result);
  return current;
}
