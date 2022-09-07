import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/agenda.dart';

abstract class AgendaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AgendaNotInitializedState extends AgendaState {}

class AgendaLoadingState extends AgendaState {}

class AgendaFailureState extends AgendaState {}

class AgendaSuccessState extends AgendaState {
  final Agenda agenda;

  AgendaSuccessState(this.agenda);

  @override
  List<Object?> get props => [agenda];
}
