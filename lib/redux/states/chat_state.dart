import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/message.dart';

abstract class ChatState extends Equatable {
  ChatState._();

  factory ChatState.loading() = ChatLoadingState;

  factory ChatState.success(List<Message> messages) = ChatSuccessState;

  factory ChatState.failure() = ChatFailureState;

  factory ChatState.notInitialized() = ChatNotInitializedState;

  @override
  List<Object?> get props => [];
}

class ChatLoadingState extends ChatState {
  ChatLoadingState() : super._();
}

class ChatSuccessState extends ChatState {
  final List<Message> messages;

  ChatSuccessState(this.messages) : super._();

  @override
  List<Object?> get props => [messages];
}

class ChatFailureState extends ChatState {
  ChatFailureState() : super._();
}

class ChatNotInitializedState extends ChatState {
  ChatNotInitializedState() : super._();
}
