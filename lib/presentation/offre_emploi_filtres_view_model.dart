import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:redux/redux.dart';

enum OffreEmploiFiltresDisplayState { LOADING, FAILURE, SUCCESS }

class OffreEmploiFiltresViewModel extends Equatable {
  final OffreEmploiFiltresDisplayState displayState;
  final int initialDistanceValue;
  final Function(int updatedDistanceValue) updateFiltres;

  OffreEmploiFiltresViewModel._({
    required this.displayState,
    required this.initialDistanceValue,
    required this.updateFiltres,
  });

  factory OffreEmploiFiltresViewModel.create(Store<AppState> store) {
    final parametersState = store.state.offreEmploiSearchParametersState;
    final searchState = store.state.offreEmploiSearchState;
    return OffreEmploiFiltresViewModel._(
      displayState: _displayState(searchState),
      initialDistanceValue: _distance(parametersState),
      updateFiltres: (updatedDistanceValue) => store.dispatch(
        OffreEmploiSearchUpdateFiltresAction(
          OffreEmploiSearchParametersFiltres.withFiltres(distance: updatedDistanceValue),
        ),
      ),
    );
  }

  @override
  List<Object?> get props => [displayState, initialDistanceValue];
}

OffreEmploiFiltresDisplayState _displayState(OffreEmploiSearchState searchState) {
  if (searchState is OffreEmploiSearchSuccessState) {
    return OffreEmploiFiltresDisplayState.SUCCESS;
  } else if (searchState is OffreEmploiSearchLoadingState) {
    return OffreEmploiFiltresDisplayState.LOADING;
  } else {
    return OffreEmploiFiltresDisplayState.FAILURE;
  }
}

int _distance(OffreEmploiSearchParametersState parametersState) {
  const defaultValue = 10;
  if (parametersState is OffreEmploiSearchParametersInitializedState) {
    return parametersState.filtres.distance ?? defaultValue;
  } else {
    return defaultValue;
  }
}
