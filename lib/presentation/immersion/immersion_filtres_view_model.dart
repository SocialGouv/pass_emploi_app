import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/features/immersion/search/immersion_search_parameters_state.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/actions/immersion_actions.dart';
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
    final parametersState = store.state.immersionSearchParametersState;
    final searchState = store.state.immersionListState;
    return ImmersionFiltresViewModel._(
      displayState: _displayState(searchState),
      initialDistanceValue: _distance(parametersState),
      updateFiltres: (updatedDistanceValue) {
        _dispatchUpdateFiltresAction(store, updatedDistanceValue);
      },
      errorMessage: _errorMessage(searchState),
    );
  }

  @override
  List<Object?> get props => [
        displayState,
        initialDistanceValue,
        errorMessage,
      ];
}

String _errorMessage(ImmersionListState searchState) {
  return searchState is ImmersionListFailureState ? Strings.genericError : "";
}

DisplayState _displayState(ImmersionListState searchState) {
  if (searchState is ImmersionListSuccessState) {
    return DisplayState.CONTENT;
  } else if (searchState is ImmersionListLoadingState) {
    return DisplayState.LOADING;
  } else {
    return DisplayState.FAILURE;
  }
}

int _distance(ImmersionSearchParametersState parametersState) {
  if (parametersState is ImmersionSearchParametersInitializedState) {
    return parametersState.filtres.distance ?? ImmersionSearchParametersFiltres.defaultDistanceValue;
  } else {
    return ImmersionSearchParametersFiltres.defaultDistanceValue;
  }
}

void _dispatchUpdateFiltresAction(Store<AppState> store, int? updatedDistanceValue) {
  store.dispatch(ImmersionSearchUpdateFiltresAction(ImmersionSearchParametersFiltres.distance(updatedDistanceValue)));
}
