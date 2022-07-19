import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/saved_search/get/saved_search_get_action.dart';

DeepLinkState deepLinkReducer(DeepLinkState current, dynamic action) {
  if (action is SavedSearchGetAction) {
    return DeepLinkState.notInitialized();
  } else if (action is ResetDeeplinkAction) {
    return DeepLinkState.notInitialized();
  } else if (action is DeepLinkAction) {
    return DeepLinkState.fromJson(action.message.data);
  } else if (action is LocalDeeplinkAction) {
    return DeepLinkState.fromJson(action.data);
  } else {
    return current;
  }
}
