import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class DiagorienteEntryPageViewModel extends Equatable {
  final DisplayState displayState;

  DiagorienteEntryPageViewModel({
    required this.displayState,
  });

  factory DiagorienteEntryPageViewModel.create(Store<AppState> store) {
    return DiagorienteEntryPageViewModel(
      displayState: _displayState(store),
    );
  }

  @override
  List<Object?> get props => [displayState];
}

DisplayState _displayState(Store<AppState> store) {
  final state = store.state.diagorientePreferencesMetierState;
  if (state is DiagorientePreferencesMetierFailureState) return DisplayState.FAILURE;
  if (state is DiagorientePreferencesMetierSuccessState) return DisplayState.CONTENT;
  return DisplayState.LOADING;
}
