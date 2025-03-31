import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_actions.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:redux/redux.dart';

class ThematiqueDemarchePageViewModel extends Equatable {
  final DisplayState displayState;
  final List<ThematiqueDemarcheItem> thematiques;
  final void Function() onRetry;

  ThematiqueDemarchePageViewModel({required this.displayState, required this.thematiques, required this.onRetry});

  factory ThematiqueDemarchePageViewModel.create(Store<AppState> store) {
    final state = store.state.thematiquesDemarcheState;
    return ThematiqueDemarchePageViewModel(
      displayState: _displayState(state),
      thematiques: _thematiques(state),
      onRetry: () => store.dispatch(ThematiqueDemarcheRequestAction()),
    );
  }

  @override
  List<Object?> get props => [displayState, thematiques];
}

List<ThematiqueDemarcheItem> _thematiques(ThematiqueDemarcheState state) {
  if (state is ThematiqueDemarcheSuccessState) {
    final thematiques = state.thematiques
        .where((e) => e.demarches.isNotEmpty)
        .map((e) => ThematiqueDemarcheItem(id: e.code, title: e.libelle))
        .toList();

    final order = [
      "Mon (nouveau) métier",
      "Ma formation professionnelle",
      "Mes candidatures",
      "Mes entretiens d'embauche",
      "Ma création ou reprise d'entreprise",
      "Mes contraintes personnelles",
      "Mes entretiens avec un conseiller"
    ];

    thematiques.sort((a, b) => order.indexOf(a.title).compareTo(order.indexOf(b.title)));
    return thematiques;
  } else {
    return <ThematiqueDemarcheItem>[];
  }
}

DisplayState _displayState(ThematiqueDemarcheState state) {
  return switch (state) {
    ThematiqueDemarcheFailureState() => DisplayState.FAILURE,
    ThematiqueDemarcheSuccessState() => DisplayState.CONTENT,
    _ => DisplayState.LOADING,
  };
}

class ThematiqueDemarcheItem extends Equatable {
  final String id;
  final String title;
  final IconData icon;

  ThematiqueDemarcheItem({required this.id, required this.title})
      : icon = switch (title) {
          "Mon (nouveau) métier" => AppIcons.work_outline_rounded,
          "Ma formation professionnelle" => AppIcons.school_outlined,
          "Mes candidatures" => AppIcons.description_outlined,
          "Mes entretiens d'embauche" => AppIcons.event,
          "Ma création ou reprise d'entreprise" => AppIcons.rocket_launch_outlined,
          "Mes contraintes personnelles" => AppIcons.health_and_safety_outlined,
          "Mes entretiens avec un conseiller" => AppIcons.person_2_outlined,
          _ => AppIcons.description_rounded,
        };

  @override
  List<Object?> get props => [id, title];
}
