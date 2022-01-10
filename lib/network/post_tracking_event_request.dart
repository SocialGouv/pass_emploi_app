import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/network/json_serializable.dart';

enum EventType { MESSAGE_ENVOYE, OFFRE_POSTULEE, OFFRE_PARTAGEE }

class Emetteur extends JsonSerializable {
  final String id;
  final LoginStructure structure;

  Emetteur({required this.id, required this.structure});

  @override
  Map<String, dynamic> toJson() => {
        "type": "JEUNE",
        "structure": _toString(structure),
        "id": id,
      };

  String _toString(LoginStructure structure) {
    switch (structure) {
      case LoginStructure.MILO:
        return "MILO";
      case LoginStructure.POLE_EMPLOI:
        return "POLE_EMPLOI";
      case LoginStructure.PASS_EMPLOI:
        return "PASS_EMPLOI";
    }
  }
}

class PostTrackingEvent extends JsonSerializable {
  final EventType event;
  final LoginStructure structure;
  final String id;

  PostTrackingEvent({required this.event, required this.structure, required this.id});

  @override
  Map<String, dynamic> toJson() => {
        "type": _toString(event),
        "emetteur": Emetteur(id: id, structure: structure).toJson(),
      };

  _toString(EventType event) {
    switch (event) {
      case EventType.MESSAGE_ENVOYE:
        return "MESSAGE_ENVOYE";
      case EventType.OFFRE_POSTULEE:
        return "OFFRE_POSTULEE";
      case EventType.OFFRE_PARTAGEE:
        return "OFFRE_PARTAGEE";
    }
  }
}
