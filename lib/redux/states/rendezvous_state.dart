import 'package:pass_emploi_app/models/rendezvous.dart';

abstract class RendezvousState {
  RendezvousState._();

  factory RendezvousState.loading() = RendezvousLoadingState;

  factory RendezvousState.success(List<Rendezvous> actions) = RendezvousSuccessState;

  factory RendezvousState.failure() = RendezvousFailureState;

  factory RendezvousState.notInitialized() = RendezvousNotInitializedState;
}

class RendezvousLoadingState extends RendezvousState {
  RendezvousLoadingState() : super._();
}

class RendezvousSuccessState extends RendezvousState {
  final List<Rendezvous> rendezvous;

  RendezvousSuccessState(this.rendezvous) : super._();
}

class RendezvousFailureState extends RendezvousState {
  RendezvousFailureState() : super._();
}

class RendezvousNotInitializedState extends RendezvousState {
  RendezvousNotInitializedState() : super._();
}
