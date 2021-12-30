import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:redux/redux.dart';

class OffreEmploiFiltresViewModel extends Equatable {
  final DisplayState displayState;
  final bool shouldDisplayDistanceFiltre;
  final int initialDistanceValue;
  final Function(int updatedDistanceValue) updateFiltres;

  OffreEmploiFiltresViewModel._({
    required this.displayState,
    required this.shouldDisplayDistanceFiltre,
    required this.initialDistanceValue,
    required this.updateFiltres,
  });

  factory OffreEmploiFiltresViewModel.create(Store<AppState> store) {
    final parametersState = store.state.offreEmploiSearchParametersState;
    final searchState = store.state.offreEmploiSearchState;
    return OffreEmploiFiltresViewModel._(
      displayState: _displayState(searchState),
      shouldDisplayDistanceFiltre: _shouldDisplayDistanceFiltre(parametersState),
      initialDistanceValue: _distance(parametersState),
      updateFiltres: (updatedDistanceValue) => store.dispatch(
        OffreEmploiSearchUpdateFiltresAction(
          OffreEmploiSearchParametersFiltres.withFiltres(distance: updatedDistanceValue),
        ),
      ),
    );
  }

  @override
  List<Object?> get props => [displayState, shouldDisplayDistanceFiltre, initialDistanceValue];
}

bool _shouldDisplayDistanceFiltre(OffreEmploiSearchParametersState parametersState) {
  if (parametersState is OffreEmploiSearchParametersInitializedState) {
    return parametersState.location?.type == LocationType.COMMUNE;
  } else {
    return false;
  }
}

DisplayState _displayState(OffreEmploiSearchState searchState) {
  if (searchState is OffreEmploiSearchSuccessState) {
    return DisplayState.CONTENT;
  } else if (searchState is OffreEmploiSearchLoadingState) {
    return DisplayState.LOADING;
  } else {
    return DisplayState.FAILURE;
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
