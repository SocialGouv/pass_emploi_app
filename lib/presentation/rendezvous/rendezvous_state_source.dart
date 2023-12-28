enum RendezvousStateSource {
  noSource,
  accueilProchainRendezvous,
  accueilLesEvenements,
  accueilLesEvenementsSession,
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

  bool get isFromEvenements => [
        RendezvousStateSource.eventListAnimationsCollectives,
        RendezvousStateSource.eventListSessionsMilo,
        RendezvousStateSource.accueilLesEvenements,
        RendezvousStateSource.accueilLesEvenementsSession,
      ].contains(this);
}
