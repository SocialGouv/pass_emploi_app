import 'package:collection/collection.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/models/version.dart';

class DeepLinkFactory {
  static DeepLink? fromJson(Map<String, dynamic> data) {
    final deepLink = _DeepLink.fromType(data["type"] as String?);
    return switch (deepLink) {
      _DeepLink.action => DetailActionDeepLink(idAction: data["id"] as String?),
      _DeepLink.message => NouveauMessageDeepLink(),
      _DeepLink.rendezvous => DetailRendezvousDeepLink(idRendezvous: data["id"] as String?),
      _DeepLink.sessionMilo => DetailSessionMiloDeepLink(idSessionMilo: data["id"] as String?),
      _DeepLink.alerte => AlerteDeepLink(idAlerte: data["id"] as String),
      _DeepLink.fonctionnalites =>
        NouvellesFonctionnalitesDeepLink(lastVersion: Version.fromString(data["version"] as String)),
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
  rendezvous([
    _Type("DETAIL_RENDEZVOUS", _Issuer.inApp),
    _Type("NEW_RENDEZVOUS", _Issuer.backend),
    _Type("DELETED_RENDEZVOUS", _Issuer.backend),
    _Type("RAPPEL_RENDEZVOUS", _Issuer.backend),
  ]),
  action([
    _Type("DETAIL_ACTION", _Issuer.backend),
    _Type("NEW_ACTION", _Issuer.backend),
  ]),
  message([_Type("NEW_MESSAGE", _Issuer.backend)]),
  sessionMilo([_Type("DETAIL_SESSION_MILO", _Issuer.backend)]),
  alerte([_Type("NOUVELLE_OFFRE", _Issuer.backend)]),
  fonctionnalites([_Type("NOUVELLES_FONCTIONNALITES", _Issuer.firebase)]),
  eventList([_Type("EVENT_LIST", _Issuer.inApp)]),
  actualisationPe([_Type("ACTUALISATION_PE", _Issuer.firebase)]),
  agenda([_Type("AGENDA", _Issuer.inApp)]),
  favoris([_Type("FAVORIS", _Issuer.maybeUnused)]),
  savedSearches([_Type("SAVED_SEARCHES", _Issuer.maybeUnused)]),
  recherche([_Type("RECHERCHE", _Issuer.inApp)]),
  outils([_Type("OUTILS", _Issuer.inApp)]);

  final List<_Type> types;

  const _DeepLink(this.types);

  static _DeepLink? fromType(String? type) {
    return _DeepLink.values.firstWhereOrNull((e) => e.types.map((t) => t.value).contains(type));
  }
}

class _Type {
  final String value;
  final _Issuer issuer;

  const _Type(this.value, this.issuer);
}

enum _Issuer { backend, inApp, firebase, maybeUnused }
