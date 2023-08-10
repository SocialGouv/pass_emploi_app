enum RendezvousStateSource {
  noSource,
  accueilProchainRendezvous,
  accueilLesEvenements,
  agenda,
  rendezvousList,
  rendezvousListSession,
  eventListAnimationsCollectives,
  eventListSessionsMilo,
  sessionMiloDetails,
  accueilProchaineSession,
  agendaSessionMilo,
}

extension RendezvousStateSourceExt on RendezvousStateSource {
  bool get isMiloDetails => this == RendezvousStateSource.sessionMiloDetails;
}
