import 'package:equatable/equatable.dart';

class ChatBrouillonState extends Equatable {
  final String? brouillon;

  ChatBrouillonState(this.brouillon);

  @override
  List<Object?> get props => [brouillon];
}