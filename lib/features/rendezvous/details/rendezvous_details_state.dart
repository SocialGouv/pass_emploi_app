import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';

abstract class RendezvousDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RendezvousDetailsNotInitializedState extends RendezvousDetailsState {}

class RendezvousDetailsLoadingState extends RendezvousDetailsState {}

class RendezvousDetailsSuccessState extends RendezvousDetailsState {
  final Rendezvous rendezvous;

  RendezvousDetailsSuccessState(this.rendezvous);

  @override
  List<Object?> get props => [rendezvous];
}

class RendezvousDetailsFailureState extends RendezvousDetailsState {}
