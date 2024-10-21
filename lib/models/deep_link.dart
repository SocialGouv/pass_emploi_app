import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/version.dart';

sealed class DeepLink extends Equatable {
  @override
  List<Object?> get props => [];
}

class ActionDeepLink extends DeepLink {
  final String idAction;

  ActionDeepLink(this.idAction);

  @override
  List<Object?> get props => [idAction];
}

class RendezvousDeepLink extends DeepLink {
  final String idRendezvous;

  RendezvousDeepLink(this.idRendezvous);

  @override
  List<Object?> get props => [idRendezvous];
}

class SessionMiloDeepLink extends DeepLink {
  final String idSessionMilo;

  SessionMiloDeepLink(this.idSessionMilo);

  @override
  List<Object?> get props => [idSessionMilo];
}

class NouveauMessageDeepLink extends DeepLink {}

class EventListDeepLink extends DeepLink {}

class NouvellesFonctionnalitesDeepLink extends DeepLink {
  final Version? lastVersion;

  NouvellesFonctionnalitesDeepLink({required this.lastVersion});

  @override
  List<Object?> get props => [lastVersion];
}

class AlerteDeepLink extends DeepLink {
  final String idAlerte;

  AlerteDeepLink({required this.idAlerte});
}

class ActualisationPeDeepLink extends DeepLink {}

class MonSuiviDeepLink extends DeepLink {}

class FavorisDeepLink extends DeepLink {}

class AlertesDeepLink extends DeepLink {}

// TODO(refonte favoris) : à supprimer ?
class RechercheDeepLink extends DeepLink {}

class OutilsDeepLink extends DeepLink {}

class BenevolatDeepLink extends DeepLink {}

class RappelCreationDemarcheDeepLink extends DeepLink {}

class RappelCreationActionDeepLink extends DeepLink {}
