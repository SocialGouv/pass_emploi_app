import 'package:pass_emploi_app/models/rendezvous.dart';

enum RendezvousListStatus { NOT_INITIALIZED, LOADING, SUCCESS, RELOADING, FAILURE }

class RendezvousListState {
  final RendezvousListStatus futurRendezVousStatus;
  final RendezvousListStatus pastRendezVousStatus;
  final List<Rendezvous> rendezvous;
  final DateTime? dateDerniereMiseAJour;

  RendezvousListState(
    this.futurRendezVousStatus,
    this.pastRendezVousStatus,
    this.rendezvous,
    this.dateDerniereMiseAJour,
  );

  RendezvousListState.notInitialized()
      : futurRendezVousStatus = RendezvousListStatus.NOT_INITIALIZED,
        pastRendezVousStatus = RendezvousListStatus.NOT_INITIALIZED,
        rendezvous = [],
        dateDerniereMiseAJour = null;

  RendezvousListState.loadingFuture()
      : futurRendezVousStatus = RendezvousListStatus.LOADING,
        pastRendezVousStatus = RendezvousListStatus.NOT_INITIALIZED,
        rendezvous = [],
        dateDerniereMiseAJour = null;

  RendezvousListState.loadingPast()
      : futurRendezVousStatus = RendezvousListStatus.SUCCESS,
        pastRendezVousStatus = RendezvousListStatus.LOADING,
        rendezvous = [],
        dateDerniereMiseAJour = null;

  RendezvousListState.reloadingFuture()
      : futurRendezVousStatus = RendezvousListStatus.RELOADING,
        pastRendezVousStatus = RendezvousListStatus.NOT_INITIALIZED,
        rendezvous = [],
        dateDerniereMiseAJour = null;

  RendezvousListState.failedFuture()
      : futurRendezVousStatus = RendezvousListStatus.FAILURE,
        pastRendezVousStatus = RendezvousListStatus.NOT_INITIALIZED,
        rendezvous = [],
        dateDerniereMiseAJour = null;

  RendezvousListState.failedPast()
      : futurRendezVousStatus = RendezvousListStatus.SUCCESS,
        pastRendezVousStatus = RendezvousListStatus.FAILURE,
        rendezvous = [],
        dateDerniereMiseAJour = null;

  RendezvousListState.successfulFuture(this.rendezvous, [this.dateDerniereMiseAJour])
      : futurRendezVousStatus = RendezvousListStatus.SUCCESS,
        pastRendezVousStatus = RendezvousListStatus.NOT_INITIALIZED;

  RendezvousListState.successful(this.rendezvous, [this.dateDerniereMiseAJour])
      : futurRendezVousStatus = RendezvousListStatus.SUCCESS,
        pastRendezVousStatus = RendezvousListStatus.SUCCESS;

  RendezvousListState copyWith({
    final RendezvousListStatus? futurRendezVousStatus,
    final RendezvousListStatus? pastRendezVousStatus,
    final List<Rendezvous>? rendezvous,
    final DateTime? dateDerniereMiseAJour,
  }) {
    return RendezvousListState(
      futurRendezVousStatus ?? this.futurRendezVousStatus,
      pastRendezVousStatus ?? this.pastRendezVousStatus,
      rendezvous ?? this.rendezvous,
      dateDerniereMiseAJour ?? this.dateDerniereMiseAJour,
    );
  }

  bool isNotInitialized() {
    return futurRendezVousStatus == RendezvousListStatus.NOT_INITIALIZED &&
        pastRendezVousStatus == RendezvousListStatus.NOT_INITIALIZED;
  }
}
