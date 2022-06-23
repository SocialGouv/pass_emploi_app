import 'package:pass_emploi_app/features/developer_option/activation/developer_options_action.dart';
import 'package:pass_emploi_app/features/developer_option/activation/developer_options_state.dart';

DeveloperOptionsState developerOptionsReducer(DeveloperOptionsState current, dynamic action) {
  if (action is DeveloperOptionsActivationSuccessAction) return DeveloperOptionsActivatedState();
  return current;
}
