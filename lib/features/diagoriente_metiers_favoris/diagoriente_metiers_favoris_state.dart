import 'package:equatable/equatable.dart';

abstract class DiagorienteMetiersFavorisState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DiagorienteMetiersFavorisNotInitializedState extends DiagorienteMetiersFavorisState {}

class DiagorienteMetiersFavorisLoadingState extends DiagorienteMetiersFavorisState {}

class DiagorienteMetiersFavorisFailureState extends DiagorienteMetiersFavorisState {}

class DiagorienteMetiersFavorisSuccessState extends DiagorienteMetiersFavorisState {
  final bool aDesMetiersFavoris;

  DiagorienteMetiersFavorisSuccessState(this.aDesMetiersFavoris);

  @override
  List<Object?> get props => [aDesMetiersFavoris];
}
