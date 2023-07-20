import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/session_milo.dart';

abstract class EventListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventListNotInitializedState extends EventListState {}

class EventListLoadingState extends EventListState {}

class EventListFailureState extends EventListState {}

class EventListSuccessState extends EventListState {
  final List<Rendezvous> animationsCollectives;
  final List<SessionMilo> sessionsMilos;

  EventListSuccessState(this.animationsCollectives, this.sessionsMilos);

  @override
  List<Object?> get props => [animationsCollectives, sessionsMilos];
}
