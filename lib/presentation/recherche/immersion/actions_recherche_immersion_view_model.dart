import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/presentation/recherche/actions_recherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ActionsRechercheImmersionViewModel extends ActionsRechercheViewModel {
  @override
  final bool withAlertButton;
  @override
  final bool withFiltreButton;
  @override
  final int? filtresCount;

  ActionsRechercheImmersionViewModel({
    required this.withAlertButton,
    required this.withFiltreButton,
    required this.filtresCount,
  });

  factory ActionsRechercheImmersionViewModel.create(Store<AppState> store) {
    final state = store.state.rechercheImmersionState;
    return ActionsRechercheImmersionViewModel(
      withAlertButton: state.withAlertButton(),
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

int? _filtresCount(ImmersionFiltresRecherche? filtres) {
  if (filtres == null) return null;
  var count = 0;
  count += filtres.distance != null && filtres.distance != ImmersionFiltresRecherche.defaultDistanceValue ? 1 : 0;
  return count > 0 ? count : null;
}
