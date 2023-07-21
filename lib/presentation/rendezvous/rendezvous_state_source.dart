enum RendezvousStateSource {
  noSource,
  accueilProchainRendezvous,
  accueilLesEvenements,
  agenda,
  rendezvousList,
  eventListAnimationsCollectives,
  eventListSessionsMilo,
  sessionMiloDetails,
}

extension RendezvousStateSourceExt on RendezvousStateSource {
  bool get isMiloList => this == RendezvousStateSource.eventListSessionsMilo;
  bool get isMiloDetails => this == RendezvousStateSource.sessionMiloDetails;
}
