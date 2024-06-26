import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/alerte/get/alerte_get_action.dart';
import 'package:pass_emploi_app/features/alerte/list/alerte_list_actions.dart';
import 'package:pass_emploi_app/features/alerte/list/alerte_list_state.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/models/alerte/immersion_alerte.dart';
import 'package:pass_emploi_app/models/alerte/offre_emploi_alerte.dart';
import 'package:pass_emploi_app/models/alerte/service_civique_alerte.dart';
import 'package:pass_emploi_app/pages/offre_filters_bottom_sheet.dart';
import 'package:pass_emploi_app/presentation/alerte/alerte_navigation_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

void _emptyFunction(OffreEmploiAlerte search) {}

void _emptyVoidFunction() {}

void _emptyImmersionFunction(ImmersionAlerte search) {}

void _emptyServiceCiviqueFunction(ServiceCiviqueAlerte search) {}

class AlerteListViewModel extends Equatable {
  final DisplayState displayState;
  final List<Alerte> alertes;
  final Function(OffreEmploiAlerte) offreEmploiSelected;
  final Function(ImmersionAlerte) offreImmersionSelected;
  final Function(ServiceCiviqueAlerte) offreServiceCiviqueSelected;
  final AlerteNavigationState searchNavigationState;
  final Function onRetry;

  AlerteListViewModel._({
    required this.displayState,
    this.alertes = const [],
    this.offreEmploiSelected = _emptyFunction,
    this.offreImmersionSelected = _emptyImmersionFunction,
    this.offreServiceCiviqueSelected = _emptyServiceCiviqueFunction,
    this.searchNavigationState = AlerteNavigationState.NONE,
    this.onRetry = _emptyVoidFunction,
  });

  factory AlerteListViewModel.createFromStore(Store<AppState> store) {
    final state = store.state.alerteListState;
    if (state is AlerteListLoadingState) return AlerteListViewModel._(displayState: DisplayState.LOADING);
    if (state is AlerteListFailureState) return AlerteListViewModel._(displayState: DisplayState.FAILURE);
    if (state is AlerteListSuccessState) {
      return AlerteListViewModel._(
        displayState: DisplayState.CONTENT,
        alertes: state.alertes.toList(),
        searchNavigationState: AlerteNavigationState.fromAppState(store.state),
        offreEmploiSelected: (alerte) => store.dispatch(FetchAlerteResultsFromIdAction(alerte.id)),
        offreImmersionSelected: (alerte) => store.dispatch(FetchAlerteResultsFromIdAction(alerte.id)),
        offreServiceCiviqueSelected: (alerte) => store.dispatch(FetchAlerteResultsFromIdAction(alerte.id)),
        onRetry: () => store.dispatch(AlerteListRequestAction()),
      );
    }
    return AlerteListViewModel._(displayState: DisplayState.LOADING);
  }

  @override
  List<Object?> get props => [displayState, alertes, searchNavigationState];

  List<Alerte> getAlertesFiltered(OffreFilter filter) {
    final alertesFiltered = switch (filter) {
      OffreFilter.emploi => alertes.whereType<OffreEmploiAlerte>().where((e) => e.onlyAlternance == false).toList(),
      OffreFilter.alternance => alertes.whereType<OffreEmploiAlerte>().where((e) => e.onlyAlternance == true).toList(),
      OffreFilter.immersion => alertes.whereType<ImmersionAlerte>().toList(),
      OffreFilter.serviceCivique => alertes.whereType<ServiceCiviqueAlerte>().toList(),
      OffreFilter.tous => alertes,
    };
    return alertesFiltered as List<Alerte>;
  }
}
