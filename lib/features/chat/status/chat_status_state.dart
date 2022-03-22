import 'package:equatable/equatable.dart';

abstract class ChatStatusState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatStatusSuccessState extends ChatStatusState {
  final int unreadMessageCount;
  final DateTime lastConseillerReading;

  ChatStatusSuccessState({required this.unreadMessageCount, required this.lastConseillerReading});

  @override
  List<Object?> get props => [unreadMessageCount, lastConseillerReading];
}

class ChatStatusNotInitializedState extends ChatStatusState {}

class ChatStatusEmptyState extends ChatStatusState {}
