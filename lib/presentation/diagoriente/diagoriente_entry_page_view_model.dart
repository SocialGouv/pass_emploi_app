import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/diagoriente_metiers_favoris/diagoriente_metiers_favoris_state.dart';
import 'package:pass_emploi_app/features/diagoriente_urls/diagoriente_urls_actions.dart';
import 'package:pass_emploi_app/features/diagoriente_urls/diagoriente_urls_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

enum DiagorienteNavigatingTo { chatBotPage }

class DiagorienteEntryPageViewModel extends Equatable {
  final Function requestUrls;
  final bool showError;
  final bool shouldDisableButtons;
  final bool showMetiersFavoris;
  final DiagorienteNavigatingTo? navigatingTo;

  DiagorienteEntryPageViewModel({
    required this.requestUrls,
    required this.showError,
    required this.shouldDisableButtons,
    required this.showMetiersFavoris,
    this.navigatingTo,
  });

  factory DiagorienteEntryPageViewModel.create(Store<AppState> store) {
    final urlState = store.state.diagorienteUrlsState;
    final favorisState = store.state.diagorienteMetiersFavorisState;
    final shouldDisableButton = urlState is DiagorienteUrlsLoadingState;
    final showError = urlState is DiagorienteUrlsFailureState || favorisState is DiagorienteMetiersFavorisFailureState;
    final navigationTo = urlState is DiagorienteUrlsSuccessState ? DiagorienteNavigatingTo.chatBotPage : null;
    final metiersFavorisState = store.state.diagorienteMetiersFavorisState;
    final showMetiersFavoris = metiersFavorisState is DiagorienteMetiersFavorisSuccessState;
    return DiagorienteEntryPageViewModel(
      shouldDisableButtons: shouldDisableButton,
      showError: showError,
      navigatingTo: navigationTo,
      showMetiersFavoris: showMetiersFavoris,
      requestUrls: () => store.dispatch(DiagorienteUrlsRequestAction()),
    );
  }

  @override
  List<Object?> get props => [showError, shouldDisableButtons, navigatingTo];
}
