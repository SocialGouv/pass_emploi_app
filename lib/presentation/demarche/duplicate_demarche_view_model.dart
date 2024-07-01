import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_actions.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_state.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/models/thematique_de_demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_store_extension.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class DuplicateDemarcheViewModel extends Equatable {
  final String demarcheId;
  final DisplayState displayState;
  final DuplicateDemarcheSourceViewModel sourceViewModel;
  final void Function() onRetry;

  DuplicateDemarcheViewModel({
    required this.demarcheId,
    required this.displayState,
    required this.sourceViewModel,
    required this.onRetry,
  });

  factory DuplicateDemarcheViewModel.create(Store<AppState> store, String demarcheId) {
    final demarche = store.getDemarcheOrNull(demarcheId);

    if (demarche == null) {
      return DuplicateDemarcheViewModel.empty();
    }

    return DuplicateDemarcheViewModel(
      demarcheId: demarcheId,
      displayState: _displayStateFromStore(store),
      sourceViewModel: _sourceViewModel(store, demarche),
      onRetry: () => store.dispatch(ThematiqueDemarcheRequestAction()),
    );
  }

  factory DuplicateDemarcheViewModel.empty() {
    return DuplicateDemarcheViewModel(
      demarcheId: "",
      displayState: DisplayState.EMPTY,
      sourceViewModel: DuplicateDemarcheNotInitializedViewModel(),
      onRetry: () {},
    );
  }

  @override
  List<Object?> get props => [demarcheId, displayState, sourceViewModel];
}

sealed class DuplicateDemarcheSourceViewModel extends Equatable {}

class DuplicateDemarcheDuReferentielViewModel extends DuplicateDemarcheSourceViewModel {
  final String thematiqueCode;
  final String demarcheDuReferentielId;
  final String? commentCode;

  DuplicateDemarcheDuReferentielViewModel({
    required this.thematiqueCode,
    required this.demarcheDuReferentielId,
    required this.commentCode,
  });

  @override
  List<Object?> get props => [thematiqueCode, demarcheDuReferentielId, commentCode];
}

class DuplicateDemarchePersonnaliseeViewModel extends DuplicateDemarcheSourceViewModel {
  final String? description;

  DuplicateDemarchePersonnaliseeViewModel({this.description});

  @override
  List<Object?> get props => [];
}

class DuplicateDemarcheNotInitializedViewModel extends DuplicateDemarcheSourceViewModel {
  @override
  List<Object?> get props => [];
}

DisplayState _displayStateFromStore(Store<AppState> store) {
  final thematiqueDemarcheState = store.state.thematiquesDemarcheState;
  return switch (thematiqueDemarcheState) {
    ThematiqueDemarcheNotInitializedState() => DisplayState.LOADING,
    ThematiqueDemarcheLoadingState() => DisplayState.LOADING,
    ThematiqueDemarcheFailureState() => DisplayState.FAILURE,
    ThematiqueDemarcheSuccessState() => DisplayState.CONTENT,
  };
}

DuplicateDemarcheSourceViewModel _sourceViewModel(Store<AppState> store, Demarche demarche) {
  final thematiqueDemarcheState = store.state.thematiquesDemarcheState;
  if (thematiqueDemarcheState is ThematiqueDemarcheSuccessState) {
    DemarcheDuReferentiel? demarcheDuReferentiel;
    ThematiqueDeDemarche? thematiqueDuReferentiel;
    for (final thematique in thematiqueDemarcheState.thematiques) {
      thematiqueDuReferentiel = thematique;
      demarcheDuReferentiel = thematique.demarches
          .firstWhereOrNull((demarcheDuReferentiel) => demarcheDuReferentiel.quoi == demarche.titre);
      if (demarcheDuReferentiel != null) {
        break;
      }
    }

    if (thematiqueDuReferentiel != null && demarcheDuReferentiel != null) {
      final commentCode =
          demarcheDuReferentiel.comments.firstWhereOrNull((comment) => comment.label == demarche.sousTitre)?.code;
      return DuplicateDemarcheDuReferentielViewModel(
        thematiqueCode: thematiqueDuReferentiel.code,
        demarcheDuReferentielId: demarcheDuReferentiel.id,
        commentCode: commentCode,
      );
    } else {
      return DuplicateDemarchePersonnaliseeViewModel(
        description: demarche.sousTitre,
      );
    }
  }

  return DuplicateDemarcheNotInitializedViewModel();
}
