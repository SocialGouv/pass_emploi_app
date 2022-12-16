import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/version.dart';

class DeepLinkState extends Equatable {
  final DateTime deepLinkOpenedAt;

  DeepLinkState() : deepLinkOpenedAt = clock.now();

  factory DeepLinkState.fromJson(Map<String, dynamic> data) {
    switch (data["type"]) {
      case "DETAIL_ACTION":
      case "NEW_ACTION":
        return DetailActionDeepLinkState(idAction: data["id"] as String?);
      case "NEW_MESSAGE":
        return NouveauMessageDeepLinkState();
      case "DETAIL_RENDEZVOUS":
      case "NEW_RENDEZVOUS":
      case "DELETED_RENDEZVOUS":
      case "RAPPEL_RENDEZVOUS":
        return DetailRendezvousDeepLinkState(idRendezvous: data["id"] as String?);
      case "NOUVELLE_OFFRE":
        return SavedSearchDeepLinkState(idSavedSearch: data["id"] as String);
      case 'NOUVELLES_FONCTIONNALITES':
        return NouvellesFonctionnalitesDeepLinkState(lastVersion: Version.fromString(data["version"] as String));
      case "EVENT_LIST":
        return EventListDeepLinkState();
      default:
        return NotInitializedDeepLinkState();
    }
  }

  factory DeepLinkState.notInitialized() => NotInitializedDeepLinkState();

  factory DeepLinkState.used() => UsedDeepLinkState();

  @override
  List<Object?> get props => [deepLinkOpenedAt];
}

class DetailActionDeepLinkState extends DeepLinkState {
  final String? idAction;

  DetailActionDeepLinkState({required this.idAction});

  @override
  List<Object?> get props => [idAction];
}

class DetailRendezvousDeepLinkState extends DeepLinkState {
  final String? idRendezvous;

  DetailRendezvousDeepLinkState({required this.idRendezvous});

  @override
  List<Object?> get props => [idRendezvous];
}

class NouveauMessageDeepLinkState extends DeepLinkState {}

class EventListDeepLinkState extends DeepLinkState {}

class NouvellesFonctionnalitesDeepLinkState extends DeepLinkState {
  final Version? lastVersion;

  NouvellesFonctionnalitesDeepLinkState({required this.lastVersion});

  @override
  List<Object?> get props => [lastVersion];
}

class SavedSearchDeepLinkState extends DeepLinkState {
  final String idSavedSearch;

  SavedSearchDeepLinkState({required this.idSavedSearch});
}

class UsedDeepLinkState extends DeepLinkState {}

class NotInitializedDeepLinkState extends DeepLinkState {}
