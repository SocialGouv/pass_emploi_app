import 'package:pass_emploi_app/models/message.dart';

abstract class ChatAction {}

class ChatLoadingAction extends ChatAction {}

class ChatSuccessAction extends ChatAction {
  final List<Message> messages;

  ChatSuccessAction(this.messages);
}

class ChatFailureAction extends ChatAction {}

class ChatConseillerMessageAction extends ChatAction {
  final int? unreadMessageCount;
  final DateTime? lastConseillerReading;

  ChatConseillerMessageAction(this.unreadMessageCount, this.lastConseillerReading);
}

class SendMessageAction extends ChatAction {
  final String message;

  SendMessageAction(this.message);
}

class LastMessageSeenAction extends ChatAction {}

class SubscribeToChatAction extends ChatAction {}

class UnsubscribeFromChatAction extends ChatAction {}

