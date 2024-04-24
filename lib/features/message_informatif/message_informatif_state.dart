import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/chat/message_informatif.dart';

sealed class MessageInformatifState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MessageInformatifNotInitializedState extends MessageInformatifState {}

class MessageInformatifLoadingState extends MessageInformatifState {}

class MessageInformatifFailureState extends MessageInformatifState {}

class MessageInformatifSuccessState extends MessageInformatifState {
  final MessageInformatif message;

  MessageInformatifSuccessState({required this.message});

  @override
  List<Object?> get props => [message];
}
