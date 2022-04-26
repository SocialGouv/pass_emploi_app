import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/network/json_serializable.dart';

enum EventType {
  MESSAGE_ENVOYE,
  OFFRE_EMPLOI_AFFICHEE,
  OFFRE_EMPLOI_POSTULEE,
  OFFRE_EMPLOI_PARTAGEE,
  OFFRE_ALTERNANCE_AFFICHEE,
  OFFRE_ALTERNANCE_POSTULEE,
  OFFRE_ALTERNANCE_PARTAGEE,
  OFFRE_IMMERSION_APPEL,
  OFFRE_IMMERSION_ENVOI_EMAIL,
  OFFRE_IMMERSION_LOCALISATION,
  OFFRE_SERVICE_CIVIQUE_POSTULEE,
  OFFRE_SERVICE_CIVIQUE_PARTAGEE,
  ACTION_LISTE,
  ACTION_DETAIL,
  RDV_DETAIL
}

class PostTrackingEmetteur extends JsonSerializable {
  final String userId;
  final LoginMode loginMode;

  PostTrackingEmetteur({required this.userId, required this.loginMode});

  @override
  Map<String, dynamic> toJson() => {
        "type": "JEUNE",
        "structure": _toString(loginMode),
        "id": userId,
      };

  String _toString(LoginMode structure) {
    switch (structure) {
      case LoginMode.MILO:
        return "MILO";
      case LoginMode.POLE_EMPLOI:
        return "POLE_EMPLOI";
      case LoginMode.PASS_EMPLOI:
        return "PASS_EMPLOI";
    }
  }
}

class PostTrackingEvent extends JsonSerializable {
  final EventType event;
  final LoginMode loginMode;
  final String userId;

  PostTrackingEvent({required this.event, required this.loginMode, required this.userId});

  @override
  Map<String, dynamic> toJson() => {
        "type": _toString(event),
        "emetteur": PostTrackingEmetteur(userId: userId, loginMode: loginMode).toJson(),
      };

  String _toString(EventType event) {
    switch (event) {
      case EventType.MESSAGE_ENVOYE:
        return "MESSAGE_ENVOYE";
      case EventType.OFFRE_EMPLOI_POSTULEE:
        return "OFFRE_EMPLOI_POSTULEE";
      case EventType.OFFRE_EMPLOI_PARTAGEE:
        return "OFFRE_EMPLOI_PARTAGEE";
      case EventType.OFFRE_ALTERNANCE_POSTULEE:
        return "OFFRE_ALTERNANCE_POSTULEE";
      case EventType.OFFRE_ALTERNANCE_PARTAGEE:
        return "OFFRE_ALTERNANCE_PARTAGEE";
      case EventType.OFFRE_IMMERSION_ENVOI_EMAIL:
        return "OFFRE_IMMERSION_ENVOI_EMAIL";
      case EventType.OFFRE_IMMERSION_LOCALISATION:
        return "OFFRE_IMMERSION_LOCALISATION";
      case EventType.OFFRE_ALTERNANCE_AFFICHEE:
        return "OFFRE_ALTERNANCE_AFFICHEE";
      case EventType.OFFRE_EMPLOI_AFFICHEE:
        return "OFFRE_EMPLOI_AFFICHEE";
      case EventType.OFFRE_IMMERSION_APPEL:
        return "OFFRE_IMMERSION_APPEL";
      case EventType.OFFRE_SERVICE_CIVIQUE_POSTULEE:
        return "OFFRE_SERVICE_CIVIQUE_POSTULEE";
      case EventType.OFFRE_SERVICE_CIVIQUE_PARTAGEE:
        return "OFFRE_SERVICE_CIVIQUE_PARTAGEE";
      case EventType.ACTION_LISTE:
        return "ACTION_LISTE";
      case EventType.ACTION_DETAIL:
        return "ACTION_DETAIL";
      case EventType.RDV_DETAIL:
        return "RDV_DETAIL";
    }
  }
}
