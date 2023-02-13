import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CriteresRechercheImmersionContenuViewModel extends Equatable {
  final DisplayState displayState;
  final Metier? initialMetier;
  final Location? initialLocation;
  final Function(Metier metier, Location location) onSearchingRequest;

  CriteresRechercheImmersionContenuViewModel({
    required this.displayState,
    required this.initialMetier,
    required this.initialLocation,
    required this.onSearchingRequest,
  });

  factory CriteresRechercheImmersionContenuViewModel.create(Store<AppState> store) {
    return CriteresRechercheImmersionContenuViewModel(
      displayState: _displayState(store),
      initialMetier: store.state.rechercheImmersionState.request?.criteres.metier,
      initialLocation: store.state.rechercheImmersionState.request?.criteres.location,
      onSearchingRequest: (metier, location) {
        store.dispatch(
          RechercheRequestAction<ImmersionCriteresRecherche, ImmersionSearchParametersFiltres>(
            RechercheRequest(
              ImmersionCriteresRecherche(metier: metier, location: location),
              ImmersionSearchParametersFiltres.noFiltres(),
              1,
            ),
          ),
        );
      },
    );
  }

  @override
  List<Object?> get props => [displayState];
}

DisplayState _displayState(Store<AppState> store) {
  final status = store.state.rechercheImmersionState.status;
  if (status == RechercheStatus.initialLoading) return DisplayState.LOADING;
  if (status == RechercheStatus.failure) return DisplayState.FAILURE;
  return DisplayState.CONTENT;
}
