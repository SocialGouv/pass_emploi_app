import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/network/json_serializable.dart';

enum EvenementEngagement {
  MESSAGE_ENVOYE,
  PIECE_JOINTE_BENEFICIAIRE_TELECHARGEE,
  PIECE_JOINTE_CONSEILLER_TELECHARGEE,
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
  ACTION_DUPLIQUEE,
  ANIMATION_COLLECTIVE_PARTAGEE,
  ANIMATION_COLLECTIVE_AFFICHEE,
  RDV_DETAIL,
  RDV_DETAIL_SESSION,
  SESSION_AFFICHEE,
  CV_PE_TELECHARGE,
  EVENEMENT_EXTERNE_PARTAGE,
  EVENEMENT_EXTERNE_PARTAGE_CONSEILLER,
  EVENEMENT_EXTERNE_INSCRIPTION,
  MESSAGE_SESSION_MILO_PARTAGE,
  MESSAGE_SUPPRIME,
  MESSAGE_MODIFIE,
  MESSAGE_ENVOYE_PJ,
}

class PostEvenementEngagement extends JsonSerializable {
  final EvenementEngagement event;
  final LoginMode loginMode;
  final String userId;
  final Brand brand;

  PostEvenementEngagement({required this.event, required this.loginMode, required this.userId, required this.brand});

  @override
  Map<String, dynamic> toJson() => {
        "type": event.serialized(),
        "emetteur": EvenementEngagementEmetteur(userId: userId, loginMode: loginMode, brand: brand).toJson(),
      };
}

class EvenementEngagementEmetteur extends JsonSerializable {
  final String userId;
  final LoginMode loginMode;
  final Brand brand;

  EvenementEngagementEmetteur({required this.userId, required this.loginMode, required this.brand});

  @override
  Map<String, dynamic> toJson() => {
        "type": 'JEUNE',
        "structure": brand.isBrsa ? 'POLE_EMPLOI_BRSA' : loginMode.serialized(),
        "id": userId,
      };
}

extension on LoginMode {
  String serialized() {
    return switch (this) {
      LoginMode.MILO => 'MILO',
      LoginMode.POLE_EMPLOI => 'POLE_EMPLOI',
      LoginMode.DEMO_PE => 'DEMO',
      LoginMode.DEMO_MILO => 'DEMO',
    };
  }
}

extension on EvenementEngagement {
  String serialized() {
    return switch (this) {
      EvenementEngagement.MESSAGE_ENVOYE => 'MESSAGE_ENVOYE',
      EvenementEngagement.PIECE_JOINTE_BENEFICIAIRE_TELECHARGEE => "PIECE_JOINTE_BENEFICIAIRE_TELECHARGEE",
      EvenementEngagement.PIECE_JOINTE_CONSEILLER_TELECHARGEE => "PIECE_JOINTE_CONSEILLER_TELECHARGEE",
      EvenementEngagement.MESSAGE_OFFRE_PARTAGEE => 'MESSAGE_OFFRE_PARTAGEE',
      EvenementEngagement.OFFRE_EMPLOI_POSTULEE => 'OFFRE_EMPLOI_POSTULEE',
      EvenementEngagement.OFFRE_EMPLOI_PARTAGEE => 'OFFRE_EMPLOI_PARTAGEE',
      EvenementEngagement.OFFRE_ALTERNANCE_POSTULEE => 'OFFRE_ALTERNANCE_POSTULEE',
      EvenementEngagement.OFFRE_ALTERNANCE_PARTAGEE => 'OFFRE_ALTERNANCE_PARTAGEE',
      EvenementEngagement.OFFRE_IMMERSION_ENVOI_EMAIL => 'OFFRE_IMMERSION_ENVOI_EMAIL',
      EvenementEngagement.OFFRE_IMMERSION_LOCALISATION => 'OFFRE_IMMERSION_LOCALISATION',
      EvenementEngagement.OFFRE_ALTERNANCE_AFFICHEE => 'OFFRE_ALTERNANCE_AFFICHEE',
      EvenementEngagement.OFFRE_EMPLOI_AFFICHEE => 'OFFRE_EMPLOI_AFFICHEE',
      EvenementEngagement.OFFRE_IMMERSION_AFFICHEE => 'OFFRE_IMMERSION_AFFICHEE',
      EvenementEngagement.OFFRE_IMMERSION_CONTACT_AFFICHEE => 'OFFRE_IMMERSION_CONTACT_AFFICHEE',
      EvenementEngagement.OFFRE_IMMERSION_APPEL => 'OFFRE_IMMERSION_APPEL',
      EvenementEngagement.OFFRE_SERVICE_CIVIQUE_AFFICHEE => 'OFFRE_SERVICE_CIVIQUE_AFFICHEE',
      EvenementEngagement.OFFRE_SERVICE_CIVIQUE_POSTULEE => 'OFFRE_SERVICE_CIVIQUE_POSTULEE',
      EvenementEngagement.OFFRE_SERVICE_CIVIQUE_PARTAGEE => 'OFFRE_SERVICE_CIVIQUE_PARTAGEE',
      EvenementEngagement.ACTION_LISTE => 'ACTION_LISTE',
      EvenementEngagement.ACTION_DETAIL => 'ACTION_DETAIL',
      EvenementEngagement.ACTION_DUPLIQUEE => 'ACTION_DUPLIQUEE',
      EvenementEngagement.ANIMATION_COLLECTIVE_PARTAGEE => 'ANIMATION_COLLECTIVE_PARTAGEE',
      EvenementEngagement.ANIMATION_COLLECTIVE_AFFICHEE => 'ANIMATION_COLLECTIVE_AFFICHEE',
      EvenementEngagement.RDV_DETAIL => 'RDV_DETAIL',
      EvenementEngagement.RDV_DETAIL_SESSION => 'RDV_DETAIL_SESSION',
      EvenementEngagement.SESSION_AFFICHEE => 'SESSION_AFFICHEE',
      EvenementEngagement.CV_PE_TELECHARGE => 'CV_PE_TELECHARGE',
      EvenementEngagement.EVENEMENT_EXTERNE_PARTAGE => 'EVENEMENT_EXTERNE_PARTAGE',
      EvenementEngagement.EVENEMENT_EXTERNE_PARTAGE_CONSEILLER => 'EVENEMENT_EXTERNE_PARTAGE_CONSEILLER',
      EvenementEngagement.EVENEMENT_EXTERNE_INSCRIPTION => 'EVENEMENT_EXTERNE_INSCRIPTION',
      EvenementEngagement.MESSAGE_SESSION_MILO_PARTAGE => 'MESSAGE_SESSION_MILO_PARTAGE',
      EvenementEngagement.MESSAGE_SUPPRIME => 'MESSAGE_SUPPRIME',
      EvenementEngagement.MESSAGE_MODIFIE => 'MESSAGE_MODIFIE',
      EvenementEngagement.MESSAGE_ENVOYE_PJ => 'MESSAGE_ENVOYE_PJ',
    };
  }
}
