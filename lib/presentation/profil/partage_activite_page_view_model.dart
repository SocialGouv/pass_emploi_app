import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/partage_activite/partage_activite_actions.dart';
import 'package:pass_emploi_app/features/partage_activite/partage_activites_state.dart';
import 'package:pass_emploi_app/features/partage_activite/update/partage_activite_update_actions.dart';
import 'package:pass_emploi_app/features/partage_activite/update/partage_activite_update_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class PartageActivitePageViewModel extends Equatable {
  final DisplayState displayState;
  final DisplayState updateState;
  final bool shareFavoris;
  final Function(bool) onPartageFavorisTap;
  final Function() onRetry;

  PartageActivitePageViewModel({
    required this.displayState,
    required this.updateState,
    required this.shareFavoris,
    required this.onPartageFavorisTap,
    required this.onRetry,
  });

  factory PartageActivitePageViewModel.create(Store<AppState> store) {
    final state = store.state.partageActiviteState;
    final updateState = store.state.partageActiviteUpdateState;
    final favoriShared = state is PartageActiviteSuccessState ? state.preferences.partageFavoris : true;
    return PartageActivitePageViewModel(
      displayState: _displayState(state),
      updateState: _updateState(updateState),
      shareFavoris: favoriShared,
      onPartageFavorisTap: (isShare) => store.dispatch(PartageActiviteUpdateRequestAction(isShare)),
      onRetry: () => store.dispatch(PartageActiviteRequestAction()),
    );
  }

  @override
  List<Object?> get props => [displayState, shareFavoris, onPartageFavorisTap];
}


DisplayState _displayState(PartageActiviteState state) {
  if (state is PartageActiviteLoadingState) return DisplayState.chargement;
  if (state is PartageActiviteFailureState) return DisplayState.erreur;
  return DisplayState.contenu;
}

DisplayState _updateState(PartageActiviteUpdateState state) {
  if (state is PartageActiviteUpdateLoadingState) return DisplayState.chargement;
  if (state is PartageActiviteUpdateFailureState) return DisplayState.erreur;
  return DisplayState.contenu;
}
