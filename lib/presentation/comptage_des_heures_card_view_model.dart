import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/comptage_des_heures/comptage_des_heures_actions.dart';
import 'package:pass_emploi_app/features/comptage_des_heures/comptage_des_heures_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

class ComptageDesHeuresCardViewModel extends Equatable {
  final DisplayState displayState;
  final String title;
  final double pourcentageHeuresValidees;
  final double pourcentageHeuresDeclarees;
  final String heuresDeclarees;
  final String heuresValidees;
  final String dateDerniereMiseAJour;
  final String emoji;
  final void Function() retry;

  ComptageDesHeuresCardViewModel._({
    required this.displayState,
    required this.title,
    required this.pourcentageHeuresValidees,
    required this.pourcentageHeuresDeclarees,
    required this.heuresDeclarees,
    required this.heuresValidees,
    required this.dateDerniereMiseAJour,
    required this.emoji,
    required this.retry,
  });

  factory ComptageDesHeuresCardViewModel.empty(DisplayState displayState) {
    return ComptageDesHeuresCardViewModel._(
      displayState: displayState,
      title: "",
      pourcentageHeuresValidees: 0,
      pourcentageHeuresDeclarees: 0,
      heuresDeclarees: "",
      heuresValidees: "",
      dateDerniereMiseAJour: "",
      emoji: "",
      retry: () {},
    );
  }

  factory ComptageDesHeuresCardViewModel.create(Store<AppState> store) {
    final state = store.state.comptageDesHeuresState;
    final displayState = _displayState(state);

    if (state is! ComptageDesHeuresSuccessState) {
      return ComptageDesHeuresCardViewModel.empty(displayState);
    }

    const nombreDheuresParSemaine = 15;

    return ComptageDesHeuresCardViewModel._(
      displayState: displayState,
      title: _title(state.comptageDesHeures.nbHeuresDeclarees),
      pourcentageHeuresValidees: min(state.comptageDesHeures.nbHeuresValidees / nombreDheuresParSemaine, 1),
      pourcentageHeuresDeclarees: min(state.comptageDesHeures.nbHeuresDeclarees / nombreDheuresParSemaine, 1),
      heuresDeclarees: state.comptageDesHeures.nbHeuresDeclarees.toInt().toString(),
      heuresValidees: state.comptageDesHeures.nbHeuresValidees.toInt().toString(),
      dateDerniereMiseAJour: Strings.updatedAgo(state.comptageDesHeures.dateDerniereMiseAJour.timeAgo()),
      emoji: _emoji(state.comptageDesHeures.nbHeuresDeclarees),
      retry: () => store.dispatch(ComptageDesHeuresRequestAction()),
    );
  }

  @override
  List<Object?> get props => [
        title,
        pourcentageHeuresValidees,
        pourcentageHeuresDeclarees,
        heuresDeclarees,
        heuresValidees,
        dateDerniereMiseAJour,
        emoji,
      ];
}

DisplayState _displayState(ComptageDesHeuresState comptageDesHeuresState) {
  return switch (comptageDesHeuresState) {
    ComptageDesHeuresNotInitializedState() => DisplayState.LOADING,
    ComptageDesHeuresLoadingState() => DisplayState.LOADING,
    ComptageDesHeuresFailureState() => DisplayState.FAILURE,
    ComptageDesHeuresSuccessState() => DisplayState.CONTENT,
  };
}

String _title(double heuresDeclarees) {
  if (heuresDeclarees < 5) {
    return Strings.comptageDesHeures0To5;
  }

  if (heuresDeclarees < 10) {
    return Strings.comptageDesHeures5To10;
  }

  if (heuresDeclarees < 15) {
    return Strings.comptageDesHeures10To15;
  }

  if (heuresDeclarees == 15) {
    return Strings.comptageDesHeures15;
  }

  return Strings.comptageDesHeures15Plus;
}

String _emoji(double heuresValidees) {
  if (heuresValidees < 5) {
    return "😉";
  }

  if (heuresValidees < 10) {
    return "🙂";
  }

  if (heuresValidees < 15) {
    return "😛";
  }

  if (heuresValidees == 15) {
    return "😍";
  }

  return "🤩";
}
