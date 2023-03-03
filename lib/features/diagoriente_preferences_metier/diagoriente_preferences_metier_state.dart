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
  final DiagorienteUrls urls;
  final bool aDesMetiersFavoris;

  DiagorientePreferencesMetierSuccessState(this.urls, this.aDesMetiersFavoris);

  @override
  List<Object?> get props => [urls, aDesMetiersFavoris];
}
