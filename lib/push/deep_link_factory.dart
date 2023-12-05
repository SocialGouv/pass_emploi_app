import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/models/version.dart';

class DeepLinkFactory {
  static DeepLink? fromJson(Map<String, dynamic> data) {
    switch (data["type"]) {
      case "DETAIL_ACTION":
      case "NEW_ACTION":
        return DetailActionDeepLink(idAction: data["id"] as String?);
      case "NEW_MESSAGE":
        return NouveauMessageDeepLink();
      case "DETAIL_RENDEZVOUS":
      case "NEW_RENDEZVOUS":
      case "DELETED_RENDEZVOUS":
      case "RAPPEL_RENDEZVOUS":
        return DetailRendezvousDeepLink(idRendezvous: data["id"] as String?);
      case "DETAIL_SESSION_MILO":
        return DetailSessionMiloDeepLink(idSessionMilo: data["id"] as String?);
      case "NOUVELLE_OFFRE":
        return AlerteDeepLink(idAlerte: data["id"] as String);
      case 'NOUVELLES_FONCTIONNALITES':
        return NouvellesFonctionnalitesDeepLink(lastVersion: Version.fromString(data["version"] as String));
      case "EVENT_LIST":
        return EventListDeepLink();
      case "ACTUALISATION_PE":
        return ActualisationPeDeepLink();
      case "AGENDA":
        return AgendaDeepLink();
      case "FAVORIS":
        return FavorisDeepLink();
      case "SAVED_SEARCHES":
        return AlertesDeepLink();
      case "RECHERCHE":
        return RechercheDeepLink();
      case "OUTILS":
        return OutilsDeepLink();
      default:
        return null;
    }
  }
}
