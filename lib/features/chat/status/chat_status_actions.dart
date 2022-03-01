class ChatConseillerMessageAction {
  final int? unreadMessageCount;
  final DateTime? lastConseillerReading;

  ChatConseillerMessageAction(this.unreadMessageCount, this.lastConseillerReading);
}

class SubscribeToChatStatusAction {}

class UnsubscribeFromChatStatusAction {}
