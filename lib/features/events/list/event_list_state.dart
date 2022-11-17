import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';

abstract class EventListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventListNotInitializedState extends EventListState {}

class EventListLoadingState extends EventListState {}

class EventListFailureState extends EventListState {}

class EventListSuccessState extends EventListState {
  final List<Rendezvous> events;

  EventListSuccessState(this.events);

  @override
  List<Object?> get props => [events];
}
