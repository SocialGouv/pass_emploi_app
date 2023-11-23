import 'package:pass_emploi_app/features/alerte/get/alerte_get_action.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';

DeepLinkState deepLinkReducer(DeepLinkState current, dynamic action) {
  if (action is FetchAlerteResultsFromIdAction) {
    return DeepLinkState.used();
  } else if (action is ResetDeeplinkAction) {
    return DeepLinkState.used();
  } else if (action is DeepLinkAction) {
    return DeepLinkState.fromJson(action.message.data);
  } else if (action is LocalDeeplinkAction) {
    return DeepLinkState.fromJson(action.data);
  } else {
    return current;
  }
}
