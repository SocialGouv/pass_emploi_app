import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/immersion/parameters/immersion_search_parameters_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
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

DisplayState _displayState(RechercheImmersionState state) {
  switch (state.status) {
    case RechercheStatus.updateLoading:
      return DisplayState.LOADING;
    case RechercheStatus.success:
      return DisplayState.CONTENT;
    default:
      return DisplayState.FAILURE;
  }
}

int _distance(RechercheImmersionState state) {
  return state.request?.filtres.distance ?? ImmersionSearchParametersFiltres.defaultDistanceValue;
}

void _dispatchUpdateFiltresAction(Store<AppState> store, int? updatedDistanceValue) {
  store.dispatch(RechercheUpdateFiltresAction(ImmersionSearchParametersFiltres.distance(updatedDistanceValue)));
}
