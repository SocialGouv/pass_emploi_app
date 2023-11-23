import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/alerte/create/alerte_create_actions.dart';
import 'package:pass_emploi_app/features/alerte/create/alerte_create_state.dart';
import 'package:pass_emploi_app/models/alerte/alerte_extractors.dart';
import 'package:pass_emploi_app/models/alerte/immersion_alerte.dart';
import 'package:pass_emploi_app/models/alerte/offre_emploi_alerte.dart';
import 'package:pass_emploi_app/models/alerte/service_civique_alerte.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

enum CreateAlerteDisplayState { SHOW_CONTENT, SHOW_LOADING, TO_DISMISS, SHOW_ERROR }

typedef OffreEmploiAlerteViewModel = AlerteViewModel<OffreEmploiAlerte>;

typedef ImmersionAlerteViewModel = AlerteViewModel<ImmersionAlerte>;

typedef ServiceCiviqueAlerteViewModel = AlerteViewModel<ServiceCiviqueAlerte>;

class AlerteViewModel<alerte_MODEL> extends Equatable {
  final Function(String title) createAlerte;
  final CreateAlerteDisplayState displayState;
  final alerte_MODEL searchModel;
  final bool Function() savingFailure;

  AlerteViewModel._({
    required this.displayState,
    required this.createAlerte,
    required this.searchModel,
    required this.savingFailure,
  });

  factory AlerteViewModel._create(
      Store<AppState> store, AbstractSearchExtractor<alerte_MODEL> search, _SearchType type) {
    return AlerteViewModel._(
      searchModel: search.getSearchFilters(store),
      displayState: _displayState(
        _getDisplayState(store, type),
      ),
      createAlerte: (title) => store.dispatch(
        AlerteCreateRequestAction(search.getSearchFilters(store), title),
      ),
      savingFailure: () => search.isFailureState(store),
    );
  }

  static OffreEmploiAlerteViewModel createForOffreEmploi(Store<AppState> store, {required bool onlyAlternance}) {
    return AlerteViewModel._create(store, OffreEmploiSearchExtractor(), _SearchType.EMPLOI);
  }

  static ImmersionAlerteViewModel createForImmersion(Store<AppState> store) {
    return AlerteViewModel._create(store, ImmersionSearchExtractor(), _SearchType.IMMERSION);
  }

  static ServiceCiviqueAlerteViewModel createForServiceCivique(Store<AppState> store) {
    return AlerteViewModel._create(store, ServiceCiviqueSearchExtractor(), _SearchType.SERVICE_CIVIQUE);
  }

  @override
  List<Object?> get props => [displayState, searchModel];
}

AlerteCreateState<Object> _getDisplayState(Store<AppState> store, _SearchType type) {
  switch (type) {
    case _SearchType.EMPLOI:
      return store.state.offreEmploiAlerteCreateState;
    case _SearchType.IMMERSION:
      return store.state.immersionAlerteCreateState;
    case _SearchType.SERVICE_CIVIQUE:
      return store.state.serviceCiviqueAlerteCreateState;
  }
}

enum _SearchType {
  EMPLOI,
  IMMERSION,
  SERVICE_CIVIQUE,
}

CreateAlerteDisplayState _displayState<T>(AlerteCreateState<T> alerteCreateState) {
  if (alerteCreateState is AlerteCreateNotInitialized<T>) {
    return CreateAlerteDisplayState.SHOW_CONTENT;
  } else if (alerteCreateState is AlerteCreateLoadingState<T>) {
    return CreateAlerteDisplayState.SHOW_LOADING;
  } else if (alerteCreateState is AlerteCreateSuccessfullyCreated<T>) {
    return CreateAlerteDisplayState.TO_DISMISS;
  } else {
    return CreateAlerteDisplayState.SHOW_ERROR;
  }
}
