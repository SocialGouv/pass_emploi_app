import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/diagoriente_urls.dart';
import 'package:pass_emploi_app/models/metier.dart';

abstract class DiagorientePreferencesMetierState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DiagorientePreferencesMetierNotInitializedState extends DiagorientePreferencesMetierState {}

class DiagorientePreferencesMetierLoadingState extends DiagorientePreferencesMetierState {}

class DiagorientePreferencesMetierFailureState extends DiagorientePreferencesMetierState {}

class DiagorientePreferencesMetierSuccessState extends DiagorientePreferencesMetierState {
  final DiagorienteUrls urls;
  final List<Metier> metiersFavoris;

  DiagorientePreferencesMetierSuccessState(this.urls, this.metiersFavoris);

  @override
  List<Object?> get props => [urls, metiersFavoris];
}
