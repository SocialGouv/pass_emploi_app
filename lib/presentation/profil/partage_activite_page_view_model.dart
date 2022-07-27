import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/share_preferences/share_preferences_state.dart';
import 'package:pass_emploi_app/features/share_preferences/update/share_preferences_update_actions.dart';
import 'package:pass_emploi_app/features/share_preferences/update/share_preferences_update_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class PartageActivitePageViewModel extends Equatable {
  final DisplayState displayState;
  final DisplayState updateState;
  final bool shareFavoris;
  final Function() onPartageFavorisTap;

  PartageActivitePageViewModel({
    required this.displayState,
    required this.updateState,
    required this.shareFavoris,
    required this.onPartageFavorisTap,
  });

  factory PartageActivitePageViewModel.create(Store<AppState> store) {
    final state = store.state.sharePreferencesState;
    final updateState = store.state.sharePreferencesUpdateState;
    final favoriShared = state is SharePreferencesSuccessState ? state.preferences.shareFavoris : true;
    return PartageActivitePageViewModel(
      displayState: _displayState(state),
      updateState: _updateState(updateState),
      shareFavoris: favoriShared,
      onPartageFavorisTap: () => store.dispatch(SharePreferencesUpdateRequestAction(!favoriShared)),
    );
  }

  @override
  List<Object?> get props => [displayState, shareFavoris, onPartageFavorisTap];
}


DisplayState _displayState(SharePreferencesState state) {
  if (state is SharePreferencesLoadingState) return DisplayState.LOADING;
  if (state is SharePreferencesFailureState) return DisplayState.FAILURE;
  return DisplayState.CONTENT;
}


DisplayState _updateState(SharePreferencesUpdateState state) {
  if (state is SharePreferencesUpdateLoadingState) return DisplayState.LOADING;
  if (state is SharePreferencesUpdateFailureState) return DisplayState.FAILURE;
  return DisplayState.CONTENT;
}

