import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_actions.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

enum DiagorienteEntryPageDisplayState { initial, loading, failure, chatBotPage }

class DiagorienteEntryPageViewModel extends Equatable {
  final DiagorienteEntryPageDisplayState displayState;
  final Function requestUrls;

  DiagorienteEntryPageViewModel({
    required this.displayState,
    required this.requestUrls,
  });

  factory DiagorienteEntryPageViewModel.create(Store<AppState> store) {
    return DiagorienteEntryPageViewModel(
      displayState: _displayState(store),
      requestUrls: () => store.dispatch(DiagorientePreferencesMetierRequestAction()),
    );
  }

  @override
  List<Object?> get props => [displayState];
}

DiagorienteEntryPageDisplayState _displayState(Store<AppState> store) {
  final state = store.state.diagorientePreferencesMetierState;
  if (state is DiagorientePreferencesMetierLoadingState) return DiagorienteEntryPageDisplayState.loading;
  if (state is DiagorientePreferencesMetierFailureState) return DiagorienteEntryPageDisplayState.failure;
  if (state is DiagorientePreferencesMetierSuccessState) return DiagorienteEntryPageDisplayState.chatBotPage;
  return DiagorienteEntryPageDisplayState.initial;
}
