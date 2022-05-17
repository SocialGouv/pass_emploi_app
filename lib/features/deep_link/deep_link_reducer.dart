import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/saved_search/get/saved_search_get_action.dart';

DeepLinkState deepLinkReducer(DeepLinkState current, dynamic action) {
  if (action is SavedSearchGetAction) {
    return DeepLinkState.used();
  } else if (action is ResetDeeplinkAction) {
    return DeepLinkState.used();
  } else if (action is DeepLinkAction) {
    return DeepLinkState(
      _extractDeepLinkFromMessage(action.message.data),
      DateTime.now(),
      _extractIdFromMessage(action.message.data),
    );
  } else if (action is LocalDeeplinkAction) {
    return DeepLinkState(
      _extractDeepLinkFromMessage(action.data),
      DateTime.now(),
      _extractIdFromMessage(action.data),
    );
  } else {
    return current;
  }
}

String? _extractIdFromMessage(Map<String, dynamic> data) {
  return data["id"] as String?;
}

DeepLink _extractDeepLinkFromMessage(Map<String, dynamic> data) {
  switch (data["type"]) {
    case "NEW_ACTION":
      return DeepLink.ROUTE_TO_ACTION;
    case "NEW_MESSAGE":
      return DeepLink.ROUTE_TO_CHAT;
    case "NEW_RENDEZVOUS":
    case "DELETED_RENDEZVOUS":
    case "RAPPEL_RENDEZVOUS":
      return DeepLink.ROUTE_TO_RENDEZVOUS;
    case "NOUVELLE_OFFRE":
      return DeepLink.SAVED_SEARCH_RESULTS;
    default:
      return DeepLink.NOT_SET;
  }
}
