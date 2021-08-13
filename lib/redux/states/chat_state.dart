import 'package:pass_emploi_app/models/message.dart';

abstract class ChatState {
  ChatState._();

  factory ChatState.loading() = ChatLoadingState;

  factory ChatState.success(List<Message> messages) = ChatSuccessState;

  factory ChatState.failure() = ChatFailureState;

  factory ChatState.notInitialized() = ChatNotInitializedState;
}

class ChatLoadingState extends ChatState {
  ChatLoadingState() : super._();
}

class ChatSuccessState extends ChatState {
  final List<Message> messages;

  ChatSuccessState(this.messages) : super._();
}

class ChatFailureState extends ChatState {
  ChatFailureState() : super._();
}

class ChatNotInitializedState extends ChatState {
  ChatNotInitializedState() : super._();
}
