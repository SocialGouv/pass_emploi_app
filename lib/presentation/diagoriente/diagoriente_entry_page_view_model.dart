import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/diagoriente_urls/diagoriente_urls_actions.dart';
import 'package:pass_emploi_app/features/diagoriente_urls/diagoriente_urls_state.dart';
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
      requestUrls: () => store.dispatch(DiagorienteUrlsRequestAction()),
    );
  }

  @override
  List<Object?> get props => [displayState];
}

DiagorienteEntryPageDisplayState _displayState(Store<AppState> store) {
  final state = store.state.diagorienteUrlsState;
  if (state is DiagorienteUrlsLoadingState) return DiagorienteEntryPageDisplayState.loading;
  if (state is DiagorienteUrlsFailureState) return DiagorienteEntryPageDisplayState.failure;
  if (state is DiagorienteUrlsSuccessState) return DiagorienteEntryPageDisplayState.chatBotPage;
  return DiagorienteEntryPageDisplayState.initial;
}
