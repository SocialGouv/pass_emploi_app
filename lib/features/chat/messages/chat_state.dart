import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/chat/message.dart';

abstract class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatNotInitializedState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatSuccessState extends ChatState {
  final List<Message> messages;

  ChatSuccessState(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatFailureState extends ChatState {}
