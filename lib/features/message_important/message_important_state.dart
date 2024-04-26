import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/chat/message_important.dart';

sealed class MessageImportantState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MessageImportantNotInitializedState extends MessageImportantState {}

class MessageImportantFailureState extends MessageImportantState {}

class MessageImportantSuccessState extends MessageImportantState {
  final MessageImportant message;

  MessageImportantSuccessState({required this.message});

  @override
  List<Object?> get props => [message];
}
