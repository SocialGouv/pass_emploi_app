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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatStatusSuccessState &&
          runtimeType == other.runtimeType &&
          unreadMessageCount == other.unreadMessageCount &&
          lastConseillerReading == other.lastConseillerReading;

  @override
  int get hashCode => unreadMessageCount.hashCode ^ lastConseillerReading.hashCode;
}

class ChatStatusNotInitializedState extends ChatStatusState {
  ChatStatusNotInitializedState() : super._();
}
