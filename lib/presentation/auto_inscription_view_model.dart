import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/auto_inscription/auto_inscription_state.dart';
import 'package:pass_emploi_app/features/session_milo_details/session_milo_details_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/auto_inscription_repository.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class AutoInscriptionViewModel extends Equatable {
  final DisplayState displayState;
  final String? errorMessage;
  final String eventTitle;

  factory AutoInscriptionViewModel.create(Store<AppState> store) {
    return AutoInscriptionViewModel(
      displayState: _displayState(store),
      errorMessage: _errorMessage(store),
      eventTitle: _eventTitle(store),
    );
  }

  AutoInscriptionViewModel({
    required this.displayState,
    required this.errorMessage,
    required this.eventTitle,
  });

  @override
  List<Object?> get props => [
        displayState,
        errorMessage,
        eventTitle,
      ];
}

String _eventTitle(Store<AppState> store) {
  final state = store.state.sessionMiloDetailsState;
  if (state is SessionMiloDetailsSuccessState) {
    return Strings.autoInscriptionConfirmation(state.details.nomSession);
  }
  return "";
}

DisplayState _displayState(Store<AppState> store) {
  return switch (store.state.autoInscriptionState) {
    AutoInscriptionFailureState() => DisplayState.FAILURE,
    AutoInscriptionSuccessState() => DisplayState.CONTENT,
    _ => DisplayState.LOADING,
  };
}

String? _errorMessage(Store<AppState> store) {
  final state = store.state.autoInscriptionState;
  if (state is AutoInscriptionFailureState) {
    return switch (state.error) {
      AutoInscriptionNombrePlacesInsuffisantes() => Strings.nombreDePlacesInssufisantesError,
      AutoInscriptionConseillerInactif() => Strings.conseillerInactifError,
      AutoInscriptionGenericError() => null,
    };
  }
  return null;
}
