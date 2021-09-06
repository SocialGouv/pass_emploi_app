abstract class ChatStatusState {
  ChatStatusState._();

  factory ChatStatusState.success(int unreadMessageCount) = ChatStatusSuccessState;

  factory ChatStatusState.notInitialized() = ChatStatusNotInitializedState;
}

class ChatStatusSuccessState extends ChatStatusState {
  final int unreadMessageCount;

  ChatStatusSuccessState(this.unreadMessageCount) : super._();
}

class ChatStatusNotInitializedState extends ChatStatusState {
  ChatStatusNotInitializedState() : super._();
}
