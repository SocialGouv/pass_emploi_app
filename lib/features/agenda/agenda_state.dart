import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/agenda.dart';

abstract class AgendaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AgendaStateNotInitializedState extends AgendaState {}

class AgendaStateLoading extends AgendaState {}

class AgendaStateSuccess extends AgendaState {
  final Agenda agenda;

  AgendaStateSuccess(this.agenda);

  @override
  List<Object?> get props => [agenda];
}
