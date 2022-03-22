import 'package:pass_emploi_app/models/rendezvous.dart';

abstract class RendezvousState {}

class RendezvousNotInitializedState extends RendezvousState {}

class RendezvousLoadingState extends RendezvousState {}

class RendezvousSuccessState extends RendezvousState {
  final List<Rendezvous> rendezvous;

  RendezvousSuccessState(this.rendezvous);
}

class RendezvousFailureState extends RendezvousState {}
