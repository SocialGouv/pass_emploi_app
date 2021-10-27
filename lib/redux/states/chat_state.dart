import 'package:flutter/foundation.dart';
import 'package:pass_emploi_app/models/message.dart';

abstract class ChatState {
  ChatState._();

  factory ChatState.loading() = ChatLoadingState;

  factory ChatState.success(List<Message> messages) = ChatSuccessState;

  factory ChatState.failure() = ChatFailureState;

  factory ChatState.notInitialized() = ChatNotInitializedState;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ChatState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class ChatLoadingState extends ChatState {
  ChatLoadingState() : super._();
}

class ChatSuccessState extends ChatState {
  final List<Message> messages;

  ChatSuccessState(this.messages) : super._();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ChatSuccessState &&
          runtimeType == other.runtimeType &&
          listEquals(messages, other.messages);

  @override
  int get hashCode => super.hashCode ^ messages.hashCode;
}

class ChatFailureState extends ChatState {
  ChatFailureState() : super._();
}

class ChatNotInitializedState extends ChatState {
  ChatNotInitializedState() : super._();
}
