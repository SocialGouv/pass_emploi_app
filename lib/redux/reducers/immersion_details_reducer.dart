import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/redux/actions/immersion_details_actions.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/reducers/reducer.dart';
import 'package:pass_emploi_app/redux/states/immersion_details_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';

class ImmersionDetailsReducer {
  final Reducer<ImmersionDetails> immersionDetailsReducer = Reducer<ImmersionDetails>();

  State<ImmersionDetails> reduce(State<ImmersionDetails> currentState, ImmersionDetailsAction action) {
    if (action is ImmersionDetailsIncompleteDataAction) {
      return ImmersionDetailsIncompleteDataState(action.immersion);
    } else {
      return immersionDetailsReducer.reduce(currentState, action);
    }
  }
}
