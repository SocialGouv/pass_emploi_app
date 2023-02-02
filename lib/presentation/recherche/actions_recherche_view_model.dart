import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:redux/redux.dart';

class ActionsRechercheViewModel extends Equatable {
  final bool withAlertButton;
  final bool withFiltreButton;
  final int? filtresCount;

  ActionsRechercheViewModel({
    required this.withAlertButton,
    required this.withFiltreButton,
    required this.filtresCount,
  });

  factory ActionsRechercheViewModel.create(Store<AppState> store) {
    final state = store.state.rechercheEmploiState;
    return ActionsRechercheViewModel(
      withAlertButton: _withAlertButton(state),
      withFiltreButton: _withFiltreButton(state),
      filtresCount: _filtresCount(state.request?.filtres),
    );
  }

  @override
  List<Object?> get props => [withAlertButton, withFiltreButton, filtresCount];
}

bool _withAlertButton(RechercheState state) {
  return [RechercheStatus.success, RechercheStatus.updateLoading].contains(state.status);
}

bool _withFiltreButton(RechercheState<EmploiCriteresRecherche, OffreEmploiSearchParametersFiltres, OffreEmploi> state) {
  if (state.request?.criteres.onlyAlternance == true) {
    return state.request?.criteres.location?.type == LocationType.COMMUNE;
  }
  return [RechercheStatus.success, RechercheStatus.updateLoading].contains(state.status);
}

int? _filtresCount(OffreEmploiSearchParametersFiltres? filtres) {
  if (filtres == null) return null;
  final activeFiltresCount = _distanceCount(filtres) + _otherFiltresCount(filtres);
  return activeFiltresCount != 0 ? activeFiltresCount : null;
}

int _distanceCount(OffreEmploiSearchParametersFiltres filtres) {
  final distanceFiltre = filtres.distance;
  return distanceFiltre != null && distanceFiltre != OffreEmploiSearchParametersFiltres.defaultDistanceValue ? 1 : 0;
}

int _otherFiltresCount(OffreEmploiSearchParametersFiltres filtres) {
  return [
    filtres.experience?.length ?? 0,
    filtres.contrat?.length ?? 0,
    filtres.duree?.length ?? 0,
    filtres.debutantOnly != null && filtres.debutantOnly == true ? 1 : 0,
  ].fold(0, (previousValue, element) => previousValue + element);
}
