import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class SessionMilo extends Equatable {
  final String id;
  final String nomSession;
  final DateTime dateDeDebut;
  final String typeLabel;

  SessionMilo({
    required this.id,
    required this.nomSession,
    required this.dateDeDebut,
    required this.typeLabel,
  });

  factory SessionMilo.fromJson(dynamic json) {
    return SessionMilo(
      id: json["id"] as String,
      nomSession: json["nomSession"] as String,
      dateDeDebut: (json["dateHeureDebut"] as String).toDateTimeUtcOnLocalTimeZone(),
      typeLabel: json["type"]["label"] as String,
    );
  }

  @override
  List<Object?> get props => [id, nomSession, dateDeDebut, typeLabel];
}
