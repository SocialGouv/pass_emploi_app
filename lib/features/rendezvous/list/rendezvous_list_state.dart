import 'package:pass_emploi_app/models/rendezvous.dart';

enum RendezvousListStatus { NOT_INITIALIZED, LOADING, SUCCESS, FAILURE }

class RendezvousListState {
  final RendezvousListStatus futurRendezVousStatus;
  final RendezvousListStatus pastRendezVousStatus;
  final List<Rendezvous> rendezvous;

  RendezvousListState(this.futurRendezVousStatus, this.pastRendezVousStatus, this.rendezvous);

  RendezvousListState.notInitialized()
      : futurRendezVousStatus = RendezvousListStatus.NOT_INITIALIZED,
        pastRendezVousStatus = RendezvousListStatus.NOT_INITIALIZED,
        rendezvous = [];

  RendezvousListState.loadingFuture()
      : futurRendezVousStatus = RendezvousListStatus.LOADING,
        pastRendezVousStatus = RendezvousListStatus.NOT_INITIALIZED,
        rendezvous = [];

  RendezvousListState.loadingPast()
      : futurRendezVousStatus = RendezvousListStatus.SUCCESS,
        pastRendezVousStatus = RendezvousListStatus.LOADING,
        rendezvous = [];

  RendezvousListState.failedFuture()
      : futurRendezVousStatus = RendezvousListStatus.FAILURE,
        pastRendezVousStatus = RendezvousListStatus.NOT_INITIALIZED,
        rendezvous = [];

  RendezvousListState.failedPast()
      : futurRendezVousStatus = RendezvousListStatus.SUCCESS,
        pastRendezVousStatus = RendezvousListStatus.FAILURE,
        rendezvous = [];

  RendezvousListState.successfulFuture(this.rendezvous)
      : futurRendezVousStatus = RendezvousListStatus.SUCCESS,
        pastRendezVousStatus = RendezvousListStatus.NOT_INITIALIZED;

  RendezvousListState.successful(this.rendezvous)
      : futurRendezVousStatus = RendezvousListStatus.SUCCESS,
        pastRendezVousStatus = RendezvousListStatus.SUCCESS;

  RendezvousListState copyWith({
    final RendezvousListStatus? futurRendezVousStatus,
    final RendezvousListStatus? pastRendezVousStatus,
    final List<Rendezvous>? rendezvous,
  }) {
    return RendezvousListState(
      futurRendezVousStatus ?? this.futurRendezVousStatus,
      pastRendezVousStatus ?? this.pastRendezVousStatus,
      rendezvous ?? this.rendezvous,
    );
  }

  bool isNotInitialized() {
    return futurRendezVousStatus == RendezvousListStatus.NOT_INITIALIZED &&
        pastRendezVousStatus == RendezvousListStatus.NOT_INITIALIZED;
  }
}
