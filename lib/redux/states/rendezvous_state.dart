import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';

abstract class RendezvousState extends Equatable {
  RendezvousState._();

  factory RendezvousState.loading() = RendezvousLoadingState;

  factory RendezvousState.success(List<Rendezvous> actions) = RendezvousSuccessState;

  factory RendezvousState.failure() = RendezvousFailureState;

  factory RendezvousState.notInitialized() = RendezvousNotInitializedState;

  @override
  List<Object?> get props => [];
}

class RendezvousLoadingState extends RendezvousState {
  RendezvousLoadingState() : super._();
}

class RendezvousSuccessState extends RendezvousState {
  final List<Rendezvous> rendezvous;

  RendezvousSuccessState(this.rendezvous) : super._();

  @override
  List<Object?> get props => [rendezvous];
}

class RendezvousFailureState extends RendezvousState {
  RendezvousFailureState() : super._();
}

class RendezvousNotInitializedState extends RendezvousState {
  RendezvousNotInitializedState() : super._();
}
