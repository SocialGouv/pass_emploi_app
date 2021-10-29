import 'package:equatable/equatable.dart';

abstract class ChatStatusState extends Equatable {
  ChatStatusState._();

  factory ChatStatusState.success({
    required int unreadMessageCount,
    required DateTime lastConseillerReading,
  }) = ChatStatusSuccessState;

  factory ChatStatusState.empty() = ChatStatusNotInitializedState;

  factory ChatStatusState.notInitialized() = ChatStatusNotInitializedState;
}

class ChatStatusSuccessState extends ChatStatusState {
  final int unreadMessageCount;
  final DateTime lastConseillerReading;

  ChatStatusSuccessState({required this.unreadMessageCount, required this.lastConseillerReading}) : super._();

  @override
  List<Object?> get props => [unreadMessageCount, lastConseillerReading];
}

class ChatStatusNotInitializedState extends ChatStatusState {
  ChatStatusNotInitializedState() : super._();

  @override
  List<Object?> get props => [];
}

class ChatStatusEmptyState extends ChatStatusState {
  ChatStatusEmptyState() : super._();

  @override
  List<Object?> get props => [];
}
