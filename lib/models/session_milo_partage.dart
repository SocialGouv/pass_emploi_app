import 'package:equatable/equatable.dart';

class SessionMiloPartage extends Equatable {
  final String id;
  final String titre;
  final String message;

  SessionMiloPartage({
    required this.id,
    required this.titre,
    required this.message,
  });

  @override
  List<Object?> get props => [id, titre, message];
}
