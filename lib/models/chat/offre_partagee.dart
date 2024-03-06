import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/chat/message.dart';

class OffrePartagee extends Equatable {
  final String id;
  final String titre;
  final String url;
  final String message;
  final OffreType type;

  OffrePartagee({
    required this.id,
    required this.titre,
    required this.url,
    required this.message,
    required this.type,
  });

  @override
  List<Object?> get props => [id, titre, url, message, type];
}
