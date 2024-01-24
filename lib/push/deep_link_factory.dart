import 'package:collection/collection.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/models/version.dart';

class DeepLinkFactory {
  static DeepLink? fromJson(Map<String, dynamic> data) {
    final deepLink = _DeepLink.fromType(data["type"] as String?);
    final id = data["id"] as String?;
    return switch (deepLink) {
      _DeepLink.action => id != null ? ActionDeepLink(id) : null,
      _DeepLink.message => NouveauMessageDeepLink(),
      _DeepLink.rendezvous => id != null ? RendezvousDeepLink(id) : null,
      _DeepLink.sessionMilo => id != null ? SessionMiloDeepLink(id) : null,
      _DeepLink.alerte => AlerteDeepLink(idAlerte: data["id"] as String),
      _DeepLink.fonctionnalites => NouvellesFonctionnalitesDeepLink(
          lastVersion: Version.fromString(data["version"] as String),
        ),
      _DeepLink.eventList => EventListDeepLink(),
      _DeepLink.actualisationPe => ActualisationPeDeepLink(),
      _DeepLink.agenda => AgendaDeepLink(),
      _DeepLink.favoris => FavorisDeepLink(),
      _DeepLink.savedSearches => AlertesDeepLink(),
      _DeepLink.recherche => RechercheDeepLink(),
      _DeepLink.outils => OutilsDeepLink(),
      null => null,
    };
  }
}

enum _DeepLink {
  rendezvous(["DETAIL_RENDEZVOUS", "NEW_RENDEZVOUS", "RAPPEL_RENDEZVOUS"]),
  action(["DETAIL_ACTION", "NEW_ACTION"]),
  message(["NEW_MESSAGE"]),
  sessionMilo(["DETAIL_SESSION_MILO"]),
  alerte(["NOUVELLE_OFFRE"]),
  fonctionnalites(["NOUVELLES_FONCTIONNALITES"]),
  eventList(["EVENT_LIST"]),
  actualisationPe(["ACTUALISATION_PE"]),
  agenda(["AGENDA"]),
  favoris(["FAVORIS"]),
  savedSearches(["SAVED_SEARCHES"]),
  recherche(["RECHERCHE"]),
  outils(["OUTILS"]);

  final List<String> possibleTypes;

  const _DeepLink(this.possibleTypes);

  static _DeepLink? fromType(String? type) {
    return _DeepLink.values.firstWhereOrNull((e) => e.possibleTypes.contains(type));
  }
}
