abstract class ChatStatusState {
  ChatStatusState._();

  factory ChatStatusState.success({
    required int unreadMessageCount,
    required DateTime lastConseillerReading,
  }) = ChatStatusSuccessState;

  factory ChatStatusState.notInitialized() = ChatStatusNotInitializedState;
}

class ChatStatusSuccessState extends ChatStatusState {
  final int unreadMessageCount;
  final DateTime lastConseillerReading;

  ChatStatusSuccessState({required this.unreadMessageCount, required this.lastConseillerReading}) : super._();
}

class ChatStatusNotInitializedState extends ChatStatusState {
  ChatStatusNotInitializedState() : super._();
}
