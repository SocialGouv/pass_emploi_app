enum RendezvousStateSource {
  noSource,
  accueilProchainRendezvous,
  accueilLesEvenements,
  accueilLesEvenementsSession,
  agenda,
  monSuivi,
  rendezvousList,
  rendezvousListSession,
  eventListAnimationsCollectives,
  eventListSessionsMilo,
  sessionMiloDetails,
  accueilProchaineSession,
  monSuiviSessionMilo,
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
