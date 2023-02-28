import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/diagoriente_urls/diagoriente_urls_actions.dart';
import 'package:pass_emploi_app/features/diagoriente_urls/diagoriente_urls_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

enum DiagorienteNavigatingTo { chatBotPage }

class DiagorienteEntryPageViewModel extends Equatable {
  final Function requestUrls;
  final bool showError;
  final bool shouldDisableButtons;
  final DiagorienteNavigatingTo? navigatingTo;

  DiagorienteEntryPageViewModel({
    required this.requestUrls,
    required this.showError,
    required this.shouldDisableButtons,
    this.navigatingTo,
  });

  factory DiagorienteEntryPageViewModel.create(Store<AppState> store) {
    final urlState = store.state.diagorienteUrlsState;
    final shouldDisableButton = urlState is DiagorienteUrlsLoadingState;
    final showError = urlState is DiagorienteUrlsFailureState;
    final navigationTo = urlState is DiagorienteUrlsSuccessState ? DiagorienteNavigatingTo.chatBotPage : null;
    return DiagorienteEntryPageViewModel(
      shouldDisableButtons: shouldDisableButton,
      showError: showError,
      navigatingTo: navigationTo,
      requestUrls: () => store.dispatch(DiagorienteUrlsRequestAction()),
    );
  }

  @override
  List<Object?> get props => [showError, shouldDisableButtons, navigatingTo];
}
