import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/models/version.dart';

class DeepLinkFactory {
  static DeepLink? fromJson(Map<String, dynamic> data) {
    switch (data["type"]) {
      case "DETAIL_ACTION": // Backend
      case "NEW_ACTION": // Backend
        return DetailActionDeepLink(idAction: data["id"] as String?);
      case "NEW_MESSAGE": // Backend
        return NouveauMessageDeepLink();
      case "DETAIL_RENDEZVOUS": // In-App
      case "NEW_RENDEZVOUS": // Backend
      case "DELETED_RENDEZVOUS": // Backend
      case "RAPPEL_RENDEZVOUS": // Backend
        return DetailRendezvousDeepLink(idRendezvous: data["id"] as String?);
      case "DETAIL_SESSION_MILO": // Backend
        return DetailSessionMiloDeepLink(idSessionMilo: data["id"] as String?);
      case "NOUVELLE_OFFRE": // Backend
        return AlerteDeepLink(idAlerte: data["id"] as String);
      case 'NOUVELLES_FONCTIONNALITES': // Firebase (mais pas utilisé ?)
        return NouvellesFonctionnalitesDeepLink(lastVersion: Version.fromString(data["version"] as String));
      case "EVENT_LIST": // In-App
        return EventListDeepLink();
      case "ACTUALISATION_PE": // Firebase
        return ActualisationPeDeepLink();
      case "AGENDA": // In-App
        return AgendaDeepLink();
      case "FAVORIS": // Unused ?
        return FavorisDeepLink();
      case "SAVED_SEARCHES": // Unused ?
        return AlertesDeepLink();
      case "RECHERCHE": // In-App
        return RechercheDeepLink();
      case "OUTILS": // In-App
        return OutilsDeepLink();
      default:
        return null;
    }
  }
}
