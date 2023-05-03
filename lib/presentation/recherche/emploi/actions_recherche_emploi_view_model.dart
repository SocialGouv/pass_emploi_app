import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/presentation/recherche/actions_recherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ActionsRechercheEmploiViewModel extends ActionsRechercheViewModel {
  @override
  final bool withAlertButton;
  @override
  final bool withFiltreButton;
  @override
  final int? filtresCount;

  ActionsRechercheEmploiViewModel({
    required this.withAlertButton,
    required this.withFiltreButton,
    required this.filtresCount,
  });

  factory ActionsRechercheEmploiViewModel.create(Store<AppState> store) {
    final state = store.state.rechercheEmploiState;
    return ActionsRechercheEmploiViewModel(
      withAlertButton: state.withAlertButton(),
      withFiltreButton: _withFiltreButton(state),
      filtresCount: _filtresCount(state.request?.filtres),
    );
  }

  @override
  List<Object?> get props => [withAlertButton, withFiltreButton, filtresCount];
}

bool _withFiltreButton(RechercheState<EmploiCriteresRecherche, EmploiFiltresRecherche, OffreEmploi> state) {
  final withFiltreButton = [RechercheStatus.success, RechercheStatus.updateLoading].contains(state.status);
  if (state.request?.criteres.rechercheType.isOnlyAlternance() == true) {
    return withFiltreButton && state.request?.criteres.location?.type == LocationType.COMMUNE;
  } else {
    return withFiltreButton;
  }
}

int? _filtresCount(EmploiFiltresRecherche? filtres) {
  if (filtres == null) return null;
  final activeFiltresCount = _distanceCount(filtres) + _otherFiltresCount(filtres);
  return activeFiltresCount != 0 ? activeFiltresCount : null;
}

int _distanceCount(EmploiFiltresRecherche filtres) {
  final distanceFiltre = filtres.distance;
  return distanceFiltre != null && distanceFiltre != EmploiFiltresRecherche.defaultDistanceValue ? 1 : 0;
}

int _otherFiltresCount(EmploiFiltresRecherche filtres) {
  return [
    filtres.experience?.length ?? 0,
    filtres.contrat?.length ?? 0,
    filtres.duree?.length ?? 0,
    filtres.debutantOnly != null && filtres.debutantOnly == true ? 1 : 0,
  ].fold(0, (previousValue, element) => previousValue + element);
}
