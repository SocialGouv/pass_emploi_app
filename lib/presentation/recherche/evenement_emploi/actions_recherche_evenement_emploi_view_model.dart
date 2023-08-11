import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/presentation/recherche/actions_recherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ActionsRechercheEvenementEmploiViewModel extends ActionsRechercheViewModel {
  @override
  final bool withAlertButton;
  @override
  final bool withFiltreButton;
  @override
  final int? filtresCount;

  ActionsRechercheEvenementEmploiViewModel({
    required this.withAlertButton,
    required this.withFiltreButton,
    required this.filtresCount,
  });

  factory ActionsRechercheEvenementEmploiViewModel.create(Store<AppState> store) {
    final state = store.state.rechercheEvenementEmploiState;
    return ActionsRechercheEvenementEmploiViewModel(
      withAlertButton: false,
      withFiltreButton: _withFiltreButton(state),
      filtresCount: _filtresCount(state.request?.filtres),
    );
  }

  @override
  List<Object?> get props => [withAlertButton, withFiltreButton, filtresCount];
}

bool _withFiltreButton(RechercheState state) {
  if (state.results?.isEmpty == true) {
    return false;
  }
  return [RechercheStatus.success, RechercheStatus.updateLoading].contains(state.status);
}

int? _filtresCount(EvenementEmploiFiltresRecherche? filtres) {
  if (filtres == null) return null;
  final int typeFiltreCount = filtres.type != null ? 1 : 0;
  final int modalitesFiltreCount = filtres.modalites?.isNotEmpty == true ? 1 : 0;
  final int dateDebutFiltreCount = filtres.dateDebut != null ? 1 : 0;
  final int dateFinFiltreCount = filtres.dateFin != null ? 1 : 0;
  final count = typeFiltreCount + modalitesFiltreCount + dateDebutFiltreCount + dateFinFiltreCount;
  return count != 0 ? count : null;
}
