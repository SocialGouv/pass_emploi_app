import 'package:pass_emploi_app/models/rendezvous.dart';

enum RendezvousStatus { NOT_INITIALIZED, LOADING, SUCCESS, FAILURE }

class RendezvousState {
  final RendezvousStatus futurRendezVousStatus;
  final RendezvousStatus pastRendezVousStatus;
  final List<Rendezvous> rendezvous;

  RendezvousState(this.futurRendezVousStatus, this.pastRendezVousStatus, this.rendezvous);

  RendezvousState.notInitialized()
      : futurRendezVousStatus = RendezvousStatus.NOT_INITIALIZED,
        pastRendezVousStatus = RendezvousStatus.NOT_INITIALIZED,
        rendezvous = [];

  RendezvousState.loadingFuture()
      : futurRendezVousStatus = RendezvousStatus.LOADING,
        pastRendezVousStatus = RendezvousStatus.NOT_INITIALIZED,
        rendezvous = [];

  RendezvousState.loadingPast()
      : futurRendezVousStatus = RendezvousStatus.SUCCESS,
        pastRendezVousStatus = RendezvousStatus.LOADING,
        rendezvous = [];

  RendezvousState.failedFuture()
      : futurRendezVousStatus = RendezvousStatus.FAILURE,
        pastRendezVousStatus = RendezvousStatus.NOT_INITIALIZED,
        rendezvous = [];

  RendezvousState.failedPast()
      : futurRendezVousStatus = RendezvousStatus.SUCCESS,
        pastRendezVousStatus = RendezvousStatus.FAILURE,
        rendezvous = [];

  RendezvousState.successfulFuture(this.rendezvous)
      : futurRendezVousStatus = RendezvousStatus.SUCCESS,
        pastRendezVousStatus = RendezvousStatus.NOT_INITIALIZED;

  RendezvousState.successful(this.rendezvous)
      : futurRendezVousStatus = RendezvousStatus.SUCCESS,
        pastRendezVousStatus = RendezvousStatus.SUCCESS;

  RendezvousState copyWith({
    final RendezvousStatus? futurRendezVousStatus,
    final RendezvousStatus? pastRendezVousStatus,
    final List<Rendezvous>? rendezvous,
  }) {
    return RendezvousState(
      futurRendezVousStatus ?? this.futurRendezVousStatus,
      pastRendezVousStatus ?? this.pastRendezVousStatus,
      rendezvous ?? this.rendezvous,
    );
  }

  bool isNotInitialized() {
    return futurRendezVousStatus == RendezvousStatus.NOT_INITIALIZED &&
        pastRendezVousStatus == RendezvousStatus.NOT_INITIALIZED;
  }
}
