import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/preferences/preferences_actions.dart';
import 'package:pass_emploi_app/features/preferences/preferences_state.dart';
import 'package:pass_emploi_app/features/preferences/update/preferences_update_actions.dart';
import 'package:pass_emploi_app/features/preferences/update/preferences_update_state.dart';
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
    final state = store.state.preferencesState;
    final updateState = store.state.preferencesUpdateState;
    final favoriShared = state is PreferencesSuccessState ? state.preferences.partageFavoris : true;
    return PartageActivitePageViewModel(
      displayState: _displayState(state),
      updateState: _updateState(updateState),
      shareFavoris: favoriShared,
      onPartageFavorisTap: (isShare) => store.dispatch(PreferencesUpdateRequestAction(isShare)),
      onRetry: () => store.dispatch(PreferencesRequestAction()),
    );
  }

  @override
  List<Object?> get props => [displayState, shareFavoris, onPartageFavorisTap];
}


DisplayState _displayState(PreferencesState state) {
  if (state is PreferencesLoadingState) return DisplayState.LOADING;
  if (state is PreferencesFailureState) return DisplayState.FAILURE;
  return DisplayState.CONTENT;
}


DisplayState _updateState(PreferencesUpdateState state) {
  if (state is PreferencesUpdateLoadingState) return DisplayState.LOADING;
  if (state is PreferencesUpdateFailureState) return DisplayState.FAILURE;
  return DisplayState.CONTENT;
}

