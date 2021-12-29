import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:redux/redux.dart';

class OffreEmploiFiltresViewModel extends Equatable {
  final int initialDistanceValue;

  OffreEmploiFiltresViewModel._(this.initialDistanceValue);

  factory OffreEmploiFiltresViewModel.create(Store<AppState> store) {
    var parametersState = store.state.offreEmploiSearchParametersState;
    return OffreEmploiFiltresViewModel._(_distance(parametersState));
  }

  @override
  List<Object?> get props => [initialDistanceValue];
}

_distance(OffreEmploiSearchParametersState parametersState) {
  const defaultValue = 10;
  if (parametersState is OffreEmploiSearchParametersInitializedState) {
    return parametersState.filtres.distance ?? defaultValue;
  } else {
    return defaultValue;
  }
}
