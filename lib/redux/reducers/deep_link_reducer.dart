import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pass_emploi_app/redux/actions/deep_link_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/deep_link_state.dart';

AppState deepLinkReducer(AppState currentState, DeepLinkAction action) {
  return currentState.copyWith(
    deepLinkState: DeepLinkState(_extractDeepLinkFromMessage(action.message), DateTime.now()),
  );
}

DeepLink _extractDeepLinkFromMessage(RemoteMessage message) {
  switch (message.data["type"]) {
    case "NEW_ACTION":
      return DeepLink.ROUTE_TO_ACTION;
    case "NEW_MESSAGE":
      return DeepLink.ROUTE_TO_CHAT;
    case "NEW_RENDEZVOUS":
    case "DELETED_RENDEZVOUS":
      return DeepLink.ROUTE_TO_RENDEZVOUS;
    default:
      return DeepLink.NOT_SET;
  }
}
