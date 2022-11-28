import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';

class EventPartage extends Equatable {
  final String id;
  final RendezvousType type;
  final String titre;
  final DateTime date;
  final String message;

  EventPartage({
    required this.id,
    required this.type,
    required this.titre,
    required this.date,
    required this.message,
  });

  @override
  List<Object?> get props => [id, type, titre, date, message];
}