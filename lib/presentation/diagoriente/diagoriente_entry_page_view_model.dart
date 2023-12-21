import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_actions.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class DiagorienteEntryPageViewModel extends Equatable {
  final DisplayState displayState;
  final bool withMetiersFavoris;
  final VoidCallback onRetry;

  DiagorienteEntryPageViewModel({
    required this.displayState,
    required this.withMetiersFavoris,
    required this.onRetry,
  });

  factory DiagorienteEntryPageViewModel.create(Store<AppState> store) {
    return DiagorienteEntryPageViewModel(
      displayState: _displayState(store),
      withMetiersFavoris: _withMetiersFavoris(store),
      onRetry: () => store.dispatch(DiagorientePreferencesMetierRequestAction(forceNoCacheOnFavoris: true)),
    );
  }

  @override
  List<Object?> get props => [displayState, withMetiersFavoris];
}

bool _withMetiersFavoris(Store<AppState> store) {
  final state = store.state.diagorientePreferencesMetierState;
  if (state is! DiagorientePreferencesMetierSuccessState) return false;
  return state.metiersFavoris.isNotEmpty;
}

DisplayState _displayState(Store<AppState> store) {
  final state = store.state.diagorientePreferencesMetierState;
  if (state is DiagorientePreferencesMetierFailureState) return DisplayState.erreur;
  if (state is DiagorientePreferencesMetierSuccessState) return DisplayState.contenu;
  return DisplayState.chargement;
}
