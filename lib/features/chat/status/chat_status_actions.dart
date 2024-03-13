import 'package:pass_emploi_app/models/conseiller_messages_info.dart';

class ChatConseillerMessageAction {
  final ConseillerMessageInfo info;

  ChatConseillerMessageAction(this.info);
}

class SubscribeToChatStatusAction {}

class UnsubscribeFromChatStatusAction {}
