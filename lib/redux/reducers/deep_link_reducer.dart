import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pass_emploi_app/redux/actions/deep_link_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/deep_link_state.dart';

AppState deepLinkReducer(AppState currentState, DeepLinkAction action) {
  return currentState.copyWith(
    deepLinkState: DeepLinkState(
        _extractDeepLinkFromMessage(action.message), DateTime.now(), _extractIdFromMessage(action.message)),
  );
}

String? _extractIdFromMessage(RemoteMessage message) {
  if (message.data["type"] == "NOUVELLE_OFFRE") {
    return message.data["id"];
  }
  return null;
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
