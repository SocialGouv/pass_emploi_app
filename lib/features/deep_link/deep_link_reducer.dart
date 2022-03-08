import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';

DeepLinkState deepLinkReducer(DeepLinkAction action) {
  return DeepLinkState(
      _extractDeepLinkFromMessage(action.message), DateTime.now(), _extractIdFromMessage(action.message));
}

String? _extractIdFromMessage(RemoteMessage message) {
  return message.data["id"] as String?;
}

DeepLink _extractDeepLinkFromMessage(RemoteMessage message) {
  switch (message.data["type"]) {
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
