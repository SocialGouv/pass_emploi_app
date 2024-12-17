import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

enum InAppNotificationType {
  newAction,
  newRendezvous,
  rappelRendezvous,
  deletedRendezvous,
  updatedRendezvous,
  newMessage,
  nouvelleOffre,
  detailAction,
  detailSessionMilo,
  deletedSessionMilo,
  rappelCreationAction,
  rappelCreationDemarche,
  unknown;

  static InAppNotificationType fromString(String type) {
    return switch (type) {
      "NEW_ACTION" => newAction,
      "NEW_RENDEZVOUS" => newRendezvous,
      "RAPPEL_RENDEZVOUS" => rappelRendezvous,
      "DELETED_RENDEZVOUS" => deletedRendezvous,
      "UPDATED_RENDEZVOUS" => updatedRendezvous,
      "NEW_MESSAGE" => newMessage,
      "NOUVELLE_OFFRE" => nouvelleOffre,
      "DETAIL_ACTION" => detailAction,
      "DETAIL_SESSION_MILO" => detailSessionMilo,
      "DELETED_SESSION_MILO" => deletedSessionMilo,
      "RAPPEL_CREATION_ACTION" => rappelCreationAction,
      "RAPPEL_CREATION_DEMARCHE" => rappelCreationDemarche,
      _ => unknown,
    };
  }
}

class InAppNotification extends Equatable {
  final String id;
  final DateTime date;
  final String titre;
  final String description;
  final InAppNotificationType type;
  final String? idObjet;

  InAppNotification({
    required this.id,
    required this.date,
    required this.titre,
    required this.description,
    required this.type,
    this.idObjet,
  });

  @override
  List<Object?> get props => [id, date, titre, description, type, idObjet];

  static InAppNotification fromJson(Map<String, dynamic> json) {
    return InAppNotification(
      id: json['id'] as String,
      date: (json['date'] as String).toDateTimeUtcOnLocalTimeZone(),
      titre: json['titre'] as String,
      description: json['description'] as String,
      type: InAppNotificationType.fromString(json['type'] as String),
      idObjet: json['idObjet'] as String?,
    );
  }
}
