import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/diagoriente_urls.dart';

abstract class DiagorientePreferencesMetierState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DiagorientePreferencesMetierNotInitializedState extends DiagorientePreferencesMetierState {}

class DiagorientePreferencesMetierLoadingState extends DiagorientePreferencesMetierState {}

class DiagorientePreferencesMetierFailureState extends DiagorientePreferencesMetierState {}

class DiagorientePreferencesMetierSuccessState extends DiagorientePreferencesMetierState {
  final DiagorienteUrls result;

  DiagorientePreferencesMetierSuccessState(this.result);

  @override
  List<Object?> get props => [result];
}
