import 'package:pass_emploi_app/models/message.dart';

abstract class ChatState {}

class ChatNotInitializedState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatSuccessState extends ChatState {
  final List<Message> messages;

  ChatSuccessState(this.messages);
}

class ChatFailureState extends ChatState {}
