import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class ImmersionFiltresViewModel extends Equatable {
  final DisplayState displayState;
  final int initialDistanceValue;
  final Function(int? updatedDistanceValue) updateFiltres;

  final String errorMessage;

  ImmersionFiltresViewModel._({
    required this.displayState,
    required this.initialDistanceValue,
    required this.updateFiltres,
    required this.errorMessage,
  });

  factory ImmersionFiltresViewModel.create(Store<AppState> store) {
    final state = store.state.rechercheImmersionState;
    return ImmersionFiltresViewModel._(
      displayState: _displayState(state),
      initialDistanceValue: _distance(state),
      updateFiltres: (updatedDistanceValue) {
        _dispatchUpdateFiltresAction(store, updatedDistanceValue);
      },
      errorMessage: _errorMessage(state),
    );
  }

  @override
  List<Object?> get props => [
        displayState,
        initialDistanceValue,
        errorMessage,
      ];
}

String _errorMessage(RechercheImmersionState state) {
  return state.status == RechercheStatus.failure ? Strings.genericError : "";
}

DisplayState _displayState(RechercheState state) {
  return switch (state.status) {
    RechercheStatus.updateLoading => DisplayState.chargement,
    RechercheStatus.success => DisplayState.contenu,
    _ => DisplayState.erreur,
  };
}

int _distance(RechercheImmersionState state) {
  return state.request?.filtres.distance ?? ImmersionFiltresRecherche.defaultDistanceValue;
}

void _dispatchUpdateFiltresAction(Store<AppState> store, int? updatedDistanceValue) {
  store.dispatch(RechercheUpdateFiltresAction(ImmersionFiltresRecherche.distance(updatedDistanceValue)));
}
