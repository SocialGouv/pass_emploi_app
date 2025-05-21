import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_state.dart';
import 'package:pass_emploi_app/features/matching_demarche/matching_demarche_state.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_actions.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_creation_state.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_store_extension.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class DuplicateDemarcheViewModel extends Equatable {
  final String demarcheId;
  final DisplayState displayState;
  final DemarcheCreationState demarcheCreationState;
  final DuplicateDemarcheSourceViewModel sourceViewModel;
  final void Function() onRetry;

  DuplicateDemarcheViewModel({
    required this.demarcheId,
    required this.displayState,
    required this.demarcheCreationState,
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
      demarcheCreationState: _demarcheCreationState(store),
      sourceViewModel: _sourceViewModel(store, demarche),
      onRetry: () => store.dispatch(ThematiqueDemarcheRequestAction()),
    );
  }

  factory DuplicateDemarcheViewModel.empty() {
    return DuplicateDemarcheViewModel(
      demarcheId: "",
      displayState: DisplayState.EMPTY,
      demarcheCreationState: DemarcheCreationPendingState(),
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
  final matchingDemarcheState = store.state.matchingDemarcheState;
  return switch (matchingDemarcheState) {
    MatchingDemarcheNotInitializedState() => DisplayState.LOADING,
    MatchingDemarcheLoadingState() => DisplayState.LOADING,
    MatchingDemarcheFailureState() => DisplayState.FAILURE,
    MatchingDemarcheSuccessState() => DisplayState.CONTENT,
  };
}

DuplicateDemarcheSourceViewModel _sourceViewModel(Store<AppState> store, Demarche demarche) {
  final matchingDemarcheState = store.state.matchingDemarcheState;

  if (matchingDemarcheState is MatchingDemarcheSuccessState) {
    final result = matchingDemarcheState.result;
    if (result != null) {
      return DuplicateDemarcheDuReferentielViewModel(
        thematiqueCode: result.thematique.code,
        demarcheDuReferentielId: result.demarcheDuReferentiel.id,
        commentCode: result.comment?.code,
      );
    }

    final description = demarche.content;
    return DuplicateDemarchePersonnaliseeViewModel(
      description: description,
    );
  }

  return DuplicateDemarcheNotInitializedViewModel();
}

DemarcheCreationState _demarcheCreationState(Store<AppState> store) {
  final createState = store.state.createDemarcheState;
  return createState is CreateDemarcheSuccessState
      ? DemarcheCreationSuccessState(createState.demarcheCreatedId)
      : DemarcheCreationPendingState();
}
