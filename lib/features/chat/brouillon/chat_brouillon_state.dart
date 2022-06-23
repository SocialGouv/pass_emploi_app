import 'package:equatable/equatable.dart';

class ChatBrouillonState extends Equatable {
  final String? message;

  ChatBrouillonState(this.message);

  @override
  List<Object?> get props => [message];
}