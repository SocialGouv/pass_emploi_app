import 'package:pass_emploi_app/models/message.dart';

abstract class ChatState {
  ChatState._();

  factory ChatState.loading() = MessageLoadingState;

  factory ChatState.success(List<Message> messages) = MessageSuccessState;

  factory ChatState.failure() = MessageFailureState;

  factory ChatState.notInitialized() = MessageNotInitializedState;
}

class MessageLoadingState extends ChatState {
  MessageLoadingState() : super._();
}

class MessageSuccessState extends ChatState {
  final List<Message> messages;

  MessageSuccessState(this.messages) : super._();
}

class MessageFailureState extends ChatState {
  MessageFailureState() : super._();
}

class MessageNotInitializedState extends ChatState {
  MessageNotInitializedState() : super._();
}
