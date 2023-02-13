import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
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

bool _withFiltreButton(RechercheState state) {
  return [RechercheStatus.success, RechercheStatus.updateLoading].contains(state.status);
}

int? _filtresCount(ImmersionSearchParametersFiltres? filtres) {
  if (filtres == null) return null;
  var count = 0;
  count +=
      filtres.distance != null && filtres.distance != ImmersionSearchParametersFiltres.defaultDistanceValue ? 1 : 0;
  return count > 0 ? count : null;
}
