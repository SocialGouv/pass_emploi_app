import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/version.dart';

sealed class DeepLink extends Equatable {
  @override
  List<Object?> get props => [];
}

class DetailActionDeepLink extends DeepLink {
  final String? idAction;

  DetailActionDeepLink({required this.idAction});

  @override
  List<Object?> get props => [idAction];
}

class DetailRendezvousDeepLink extends DeepLink {
  final String? idRendezvous;

  DetailRendezvousDeepLink({required this.idRendezvous});

  @override
  List<Object?> get props => [idRendezvous];
}

class DetailSessionMiloDeepLink extends DeepLink {
  final String? idSessionMilo;

  DetailSessionMiloDeepLink({required this.idSessionMilo});

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

class AgendaDeepLink extends DeepLink {}

class FavorisDeepLink extends DeepLink {}

class AlertesDeepLink extends DeepLink {}

class RechercheDeepLink extends DeepLink {}

class OutilsDeepLink extends DeepLink {}
