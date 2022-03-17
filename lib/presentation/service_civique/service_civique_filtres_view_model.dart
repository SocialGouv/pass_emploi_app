import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/service_civique/search/service_civique_search_result_state.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';
import 'package:redux/redux.dart';

import '../../features/service_civique/search/search_service_civique_actions.dart';
import '../../models/service_civique/domain.dart';

const int defaultDistanceValue = 10;

class ServiceCiviqueFiltresViewModel extends Equatable {
  final DisplayState displayState;
  final bool shouldDisplayDistanceFiltre;
  final int initialDistanceValue;
  final Domain initialDomainValue;
  final DateTime? initialStartDateValue;
  final Function(
    int? updatedDistance,
    Domain? updatedDomain,
    DateTime? updatedStartDate,
  ) updateFiltres;
  final String errorMessage;

  ServiceCiviqueFiltresViewModel._({
    required this.displayState,
    required this.shouldDisplayDistanceFiltre,
    required this.initialDistanceValue,
    required this.updateFiltres,
    required this.errorMessage,
    required this.initialDomainValue,
    required this.initialStartDateValue,
  });

  factory ServiceCiviqueFiltresViewModel.create(Store<AppState> store) {
    final searchResultsState = store.state.serviceCiviqueSearchResultState;
    return ServiceCiviqueFiltresViewModel._(
      displayState: _displayState(searchResultsState),
      shouldDisplayDistanceFiltre: _shouldDisplayDistanceFiltre(searchResultsState),
      initialDistanceValue: _distance(searchResultsState),
      initialDomainValue: _domain(searchResultsState),
      initialStartDateValue: _startDate(searchResultsState),
      updateFiltres: (updatedDistance, updatedDomain, updatedStartDate) {
        _dispatchUpdateFiltresAction(store, updatedDistance, updatedDomain, updatedStartDate);
      },
      errorMessage: _errorMessage(searchResultsState),
    );
  }

  @override
  List<Object?> get props => [
        displayState,
        shouldDisplayDistanceFiltre,
        initialDistanceValue,
        initialDomainValue,
        initialStartDateValue,
      ];
}

String _errorMessage(ServiceCiviqueSearchResultState searchState) {
  return searchState is ServiceCiviqueSearchResultErrorState ? Strings.genericError : "";
}

bool _shouldDisplayDistanceFiltre(ServiceCiviqueSearchResultState state) {
  if (state is ServiceCiviqueSearchResultDataState) {
    return state.lastRequest.location?.type == LocationType.COMMUNE;
  } else {
    return false;
  }
}

DisplayState _displayState(ServiceCiviqueSearchResultState searchResultsState) {
  if (searchResultsState is ServiceCiviqueSearchResultDataState) {
    return DisplayState.CONTENT;
  } else if (searchResultsState is ServiceCiviqueSearchResultLoadingState) {
    return DisplayState.LOADING;
  } else {
    return DisplayState.FAILURE;
  }
}

int _distance(ServiceCiviqueSearchResultState state) {
  if (state is ServiceCiviqueSearchResultDataState) {
    return state.lastRequest.distance ?? defaultDistanceValue;
  } else {
    return defaultDistanceValue;
  }
}

Domain _domain(ServiceCiviqueSearchResultState state) {
  if (state is ServiceCiviqueSearchResultDataState) {
    return Domain.fromTag(state.lastRequest.domain) ?? Domain.values.first;
  } else {
    return Domain.values.first;
  }
}

DateTime? _startDate(ServiceCiviqueSearchResultState state) {
  if (state is ServiceCiviqueSearchResultDataState) {
    return state.lastRequest.startDate?.toDateTimeUtcOnLocalTimeZone();
  } else {
    return null;
  }
}

void _dispatchUpdateFiltresAction(
  Store<AppState> store,
  int? updatedDistanceValue,
  Domain? updatedDomain,
  DateTime? updatedStartDate,
) {
  store.dispatch(
    ServiceCiviqueSearchUpdateFiltresAction(
      distance: updatedDistanceValue,
      startDate: updatedStartDate,
      domain: updatedDomain,
    ),
  );
}
