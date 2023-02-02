import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/location/search_location_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class BlocCriteresRechercheContenuViewModel extends Equatable {
  final DisplayState displayState;
  final List<LocationViewModel> locations;
  final Function(String? input) onInputLocation;

  BlocCriteresRechercheContenuViewModel({
    required this.displayState,
    required this.locations,
    required this.onInputLocation,
  });

  factory BlocCriteresRechercheContenuViewModel.create(Store<AppState> store) {
    return BlocCriteresRechercheContenuViewModel(
      displayState: _displayState(store),
      locations: store.state.searchLocationState.locations
          .map((location) => LocationViewModel.fromLocation(location))
          .toList(),
      onInputLocation: (input) => store.dispatch(SearchLocationRequestAction(input)),
    );
  }

  @override
  List<Object?> get props => [displayState, locations];
}

DisplayState _displayState(Store<AppState> store) {
  final status = store.state.rechercheEmploiState.status;
  if (status == RechercheStatus.initialLoading) return DisplayState.LOADING;
  if (status == RechercheStatus.failure) return DisplayState.FAILURE;
  return DisplayState.CONTENT;
}
