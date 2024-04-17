import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/network/json_serializable.dart';

enum EventType {
  MESSAGE_ENVOYE,
  PIECE_JOINTE_TELECHARGEE,
  MESSAGE_OFFRE_PARTAGEE,
  OFFRE_EMPLOI_AFFICHEE,
  OFFRE_EMPLOI_POSTULEE,
  OFFRE_EMPLOI_PARTAGEE,
  OFFRE_ALTERNANCE_AFFICHEE,
  OFFRE_ALTERNANCE_POSTULEE,
  OFFRE_ALTERNANCE_PARTAGEE,
  OFFRE_IMMERSION_AFFICHEE,
  OFFRE_IMMERSION_CONTACT_AFFICHEE,
  OFFRE_IMMERSION_APPEL,
  OFFRE_IMMERSION_ENVOI_EMAIL,
  OFFRE_IMMERSION_LOCALISATION,
  OFFRE_SERVICE_CIVIQUE_AFFICHEE,
  OFFRE_SERVICE_CIVIQUE_POSTULEE,
  OFFRE_SERVICE_CIVIQUE_PARTAGEE,
  ACTION_LISTE,
  ACTION_DETAIL,
  ANIMATION_COLLECTIVE_PARTAGEE,
  ANIMATION_COLLECTIVE_AFFICHEE,
  RDV_DETAIL,
  CV_PE_TELECHARGE,
  EVENEMENT_EXTERNE_PARTAGE,
  EVENEMENT_EXTERNE_PARTAGE_CONSEILLER,
  EVENEMENT_EXTERNE_INSCRIPTION,
  MESSAGE_SESSION_MILO_PARTAGE,
  MESSAGE_SUPPRIME,
  MESSAGE_MODIFIE,
  IMAGE_ENVOYEE,
}

class PostTrackingEmetteur extends JsonSerializable {
  final String userId;
  final LoginMode loginMode;
  final Brand brand;

  PostTrackingEmetteur({required this.userId, required this.loginMode, required this.brand});

  @override
  Map<String, dynamic> toJson() => {
        "type": 'JEUNE',
        "structure": brand.isBrsa ? 'POLE_EMPLOI_BRSA' : loginMode.serialized(),
        "id": userId,
      };
}

class PostTrackingEvent extends JsonSerializable {
  final EventType event;
  final LoginMode loginMode;
  final String userId;
  final Brand brand;

  PostTrackingEvent({required this.event, required this.loginMode, required this.userId, required this.brand});

  @override
  Map<String, dynamic> toJson() => {
        "type": event.serialized(),
        "emetteur": PostTrackingEmetteur(userId: userId, loginMode: loginMode, brand: brand).toJson(),
      };
}

extension on LoginMode {
  String serialized() {
    return switch (this) {
      LoginMode.MILO => 'MILO',
      LoginMode.POLE_EMPLOI => 'POLE_EMPLOI',
      LoginMode.PASS_EMPLOI => 'PASS_EMPLOI',
      LoginMode.DEMO_PE => 'DEMO',
      LoginMode.DEMO_MILO => 'DEMO',
    };
  }
}

extension on EventType {
  String serialized() {
    return switch (this) {
      EventType.MESSAGE_ENVOYE => 'MESSAGE_ENVOYE',
      EventType.PIECE_JOINTE_TELECHARGEE => 'PIECE_JOINTE_TELECHARGEE',
      EventType.MESSAGE_OFFRE_PARTAGEE => 'MESSAGE_OFFRE_PARTAGEE',
      EventType.OFFRE_EMPLOI_POSTULEE => 'OFFRE_EMPLOI_POSTULEE',
      EventType.OFFRE_EMPLOI_PARTAGEE => 'OFFRE_EMPLOI_PARTAGEE',
      EventType.OFFRE_ALTERNANCE_POSTULEE => 'OFFRE_ALTERNANCE_POSTULEE',
      EventType.OFFRE_ALTERNANCE_PARTAGEE => 'OFFRE_ALTERNANCE_PARTAGEE',
      EventType.OFFRE_IMMERSION_ENVOI_EMAIL => 'OFFRE_IMMERSION_ENVOI_EMAIL',
      EventType.OFFRE_IMMERSION_LOCALISATION => 'OFFRE_IMMERSION_LOCALISATION',
      EventType.OFFRE_ALTERNANCE_AFFICHEE => 'OFFRE_ALTERNANCE_AFFICHEE',
      EventType.OFFRE_EMPLOI_AFFICHEE => 'OFFRE_EMPLOI_AFFICHEE',
      EventType.OFFRE_IMMERSION_AFFICHEE => 'OFFRE_IMMERSION_AFFICHEE',
      EventType.OFFRE_IMMERSION_CONTACT_AFFICHEE => 'OFFRE_IMMERSION_CONTACT_AFFICHEE',
      EventType.OFFRE_IMMERSION_APPEL => 'OFFRE_IMMERSION_APPEL',
      EventType.OFFRE_SERVICE_CIVIQUE_AFFICHEE => 'OFFRE_SERVICE_CIVIQUE_AFFICHEE',
      EventType.OFFRE_SERVICE_CIVIQUE_POSTULEE => 'OFFRE_SERVICE_CIVIQUE_POSTULEE',
      EventType.OFFRE_SERVICE_CIVIQUE_PARTAGEE => 'OFFRE_SERVICE_CIVIQUE_PARTAGEE',
      EventType.ACTION_LISTE => 'ACTION_LISTE',
      EventType.ACTION_DETAIL => 'ACTION_DETAIL',
      EventType.ANIMATION_COLLECTIVE_PARTAGEE => 'ANIMATION_COLLECTIVE_PARTAGEE',
      EventType.ANIMATION_COLLECTIVE_AFFICHEE => 'ANIMATION_COLLECTIVE_AFFICHEE',
      EventType.RDV_DETAIL => 'RDV_DETAIL',
      EventType.CV_PE_TELECHARGE => 'CV_PE_TELECHARGE',
      EventType.EVENEMENT_EXTERNE_PARTAGE => 'EVENEMENT_EXTERNE_PARTAGE',
      EventType.EVENEMENT_EXTERNE_PARTAGE_CONSEILLER => 'EVENEMENT_EXTERNE_PARTAGE_CONSEILLER',
      EventType.EVENEMENT_EXTERNE_INSCRIPTION => 'EVENEMENT_EXTERNE_INSCRIPTION',
      EventType.MESSAGE_SESSION_MILO_PARTAGE => 'MESSAGE_SESSION_MILO_PARTAGE',
      EventType.MESSAGE_SUPPRIME => 'MESSAGE_SUPPRIME',
      EventType.MESSAGE_MODIFIE => 'MESSAGE_MODIFIE',
      EventType.IMAGE_ENVOYEE => 'IMAGE_ENVOYEE',
    };
  }
}
