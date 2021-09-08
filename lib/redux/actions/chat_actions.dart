import 'package:pass_emploi_app/models/message.dart';

abstract class ChatAction {}

class ChatLoadingAction extends ChatAction {}

class ChatSuccessAction extends ChatAction {
  final List<Message> messages;

  ChatSuccessAction(this.messages);
}

class ChatFailureAction extends ChatAction {}

class ChatUnseenMessageAction extends ChatAction {
  final int unreadMessageCount;

  ChatUnseenMessageAction(this.unreadMessageCount);
}
