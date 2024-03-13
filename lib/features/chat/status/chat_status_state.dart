import 'package:equatable/equatable.dart';

sealed class ChatStatusState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatStatusSuccessState extends ChatStatusState {
  final bool hasUnreadMessages;
  final DateTime lastConseillerReading;

  ChatStatusSuccessState({required this.hasUnreadMessages, required this.lastConseillerReading});

  @override
  List<Object?> get props => [hasUnreadMessages, lastConseillerReading];
}

class ChatStatusNotInitializedState extends ChatStatusState {}

class ChatStatusEmptyState extends ChatStatusState {}
