import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/network/json_serializable.dart';

enum EventType { MESSAGE_ENVOYE, OFFRE_POSTULEE, OFFRE_PARTAGEE }

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
