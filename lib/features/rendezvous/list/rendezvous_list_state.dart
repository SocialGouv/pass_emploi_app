import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/session_milo.dart';

enum RendezvousListStatus { NOT_INITIALIZED, LOADING, SUCCESS, RELOADING, FAILURE }

class RendezvousListState {
  final RendezvousListStatus futurRendezVousStatus;
  final RendezvousListStatus pastRendezVousStatus;
  final List<Rendezvous> rendezvous;
  final List<SessionMilo> sessionsMilo;
  final DateTime? dateDerniereMiseAJour;

  RendezvousListState({
    required this.futurRendezVousStatus,
    required this.pastRendezVousStatus,
    required this.rendezvous,
    required this.sessionsMilo,
    required this.dateDerniereMiseAJour,
  });

  RendezvousListState.notInitialized()
      : futurRendezVousStatus = RendezvousListStatus.NOT_INITIALIZED,
        pastRendezVousStatus = RendezvousListStatus.NOT_INITIALIZED,
        rendezvous = [],
        sessionsMilo = [],
        dateDerniereMiseAJour = null;

  RendezvousListState.loadingFuture()
      : futurRendezVousStatus = RendezvousListStatus.LOADING,
        pastRendezVousStatus = RendezvousListStatus.NOT_INITIALIZED,
        rendezvous = [],
        sessionsMilo = [],
        dateDerniereMiseAJour = null;

  RendezvousListState.loadingPast()
      : futurRendezVousStatus = RendezvousListStatus.SUCCESS,
        pastRendezVousStatus = RendezvousListStatus.LOADING,
        rendezvous = [],
        sessionsMilo = [],
        dateDerniereMiseAJour = null;

  RendezvousListState.reloadingFuture()
      : futurRendezVousStatus = RendezvousListStatus.RELOADING,
        pastRendezVousStatus = RendezvousListStatus.NOT_INITIALIZED,
        rendezvous = [],
        sessionsMilo = [],
        dateDerniereMiseAJour = null;

  RendezvousListState.failedFuture()
      : futurRendezVousStatus = RendezvousListStatus.FAILURE,
        pastRendezVousStatus = RendezvousListStatus.NOT_INITIALIZED,
        rendezvous = [],
        sessionsMilo = [],
        dateDerniereMiseAJour = null;

  RendezvousListState.failedPast()
      : futurRendezVousStatus = RendezvousListStatus.SUCCESS,
        pastRendezVousStatus = RendezvousListStatus.FAILURE,
        rendezvous = [],
        sessionsMilo = [],
        dateDerniereMiseAJour = null;

  RendezvousListState.successfulFuture({
    this.rendezvous = const [],
    this.sessionsMilo = const [],
    this.dateDerniereMiseAJour,
  })  : futurRendezVousStatus = RendezvousListStatus.SUCCESS,
        pastRendezVousStatus = RendezvousListStatus.NOT_INITIALIZED;

  RendezvousListState.successful({
    this.rendezvous = const [],
    this.sessionsMilo = const [],
    this.dateDerniereMiseAJour,
  })  : futurRendezVousStatus = RendezvousListStatus.SUCCESS,
        pastRendezVousStatus = RendezvousListStatus.SUCCESS;

  RendezvousListState copyWith({
    final RendezvousListStatus? futurRendezVousStatus,
    final RendezvousListStatus? pastRendezVousStatus,
    final List<Rendezvous>? rendezvous,
    final List<SessionMilo>? sessionsMilo,
    final DateTime? Function()? dateDerniereMiseAJour,
  }) {
    return RendezvousListState(
      futurRendezVousStatus: futurRendezVousStatus ?? this.futurRendezVousStatus,
      pastRendezVousStatus: pastRendezVousStatus ?? this.pastRendezVousStatus,
      rendezvous: rendezvous ?? this.rendezvous,
      sessionsMilo: sessionsMilo ?? this.sessionsMilo,
      dateDerniereMiseAJour: dateDerniereMiseAJour != null ? dateDerniereMiseAJour() : this.dateDerniereMiseAJour,
    );
  }

  bool isNotInitialized() {
    return futurRendezVousStatus == RendezvousListStatus.NOT_INITIALIZED &&
        pastRendezVousStatus == RendezvousListStatus.NOT_INITIALIZED;
  }
}
