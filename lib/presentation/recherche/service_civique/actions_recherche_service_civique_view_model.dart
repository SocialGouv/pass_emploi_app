import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/models/service_civique/domain.dart';
import 'package:pass_emploi_app/presentation/recherche/actions_recherche_view_model.dart';
import 'package:pass_emploi_app/presentation/service_civique/service_civique_filtres_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ActionsRechercheServiceCiviqueViewModel extends ActionsRechercheViewModel {
  @override
  final bool withAlertButton;
  @override
  final bool withFiltreButton;
  @override
  final int? filtresCount;

  ActionsRechercheServiceCiviqueViewModel({
    required this.withAlertButton,
    required this.withFiltreButton,
    required this.filtresCount,
  });

  factory ActionsRechercheServiceCiviqueViewModel.create(Store<AppState> store) {
    final state = store.state.rechercheServiceCiviqueState;
    return ActionsRechercheServiceCiviqueViewModel(
      withAlertButton: state.withAlertButton(),
      withFiltreButton: _withFiltreButton(state),
      filtresCount: _filtresCount(state.request?.filtres),
    );
  }

  @override
  List<Object?> get props => [withAlertButton, withFiltreButton, filtresCount];
}

bool _withFiltreButton(RechercheState state) {
  return [RechercheStatus.success, RechercheStatus.updateLoading].contains(state.status);
}

int? _filtresCount(ServiceCiviqueFiltresRecherche? filtres) {
  if (filtres == null) return null;
  final int distanceCount =
      filtres.distance != null && filtres.distance != defaultDistanceValueOnServiceCiviqueFiltre ? 1 : 0;
  final int startDateCount = filtres.startDate != null ? 1 : 0;
  final int domainCount = filtres.domain != null && filtres.domain != Domaine.all ? 1 : 0;
  final count = distanceCount + startDateCount + domainCount;
  return count != 0 ? count : null;
}
