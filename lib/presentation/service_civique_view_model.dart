import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/service_civique/search/search_service_civique_actions.dart';
import 'package:pass_emploi_app/features/service_civique/search/service_civique_search_result_state.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/presentation/service_civique/service_civique_filtres_view_model.dart';
import 'package:pass_emploi_app/repositories/service_civique_repository.dart';
import 'package:redux/redux.dart';

import '../features/location/search_location_actions.dart';
import '../features/service_civique/search/search_service_civique_actions.dart';
import '../models/service_civique.dart';
import '../models/service_civique/domain.dart';
import '../redux/app_state.dart';

class ServiceCiviqueViewModel extends Equatable {
  final List<LocationViewModel> locations;
  final Function(Location? location) onSearchRequest;
  final Function(String? input) onInputLocation;
  final DisplayState displayState;
  final Function() onLoadMore;
  final Function() onRetry;
  final List<ServiceCivique> items;
  final bool displayLoaderAtBottomOfList;
  final int? filtresCount;

  ServiceCiviqueViewModel._({
    required this.locations,
    required this.onSearchRequest,
    required this.onInputLocation,
    required this.displayState,
    required this.onLoadMore,
    required this.items,
    required this.displayLoaderAtBottomOfList,
    required this.onRetry,
    required this.filtresCount,
  });

  factory ServiceCiviqueViewModel.create(Store<AppState> store) {
    var searchResultState = store.state.serviceCiviqueSearchResultState;
    return ServiceCiviqueViewModel._(
        locations: store.state.searchLocationState.locations
            .map((location) => LocationViewModel.fromLocation(location))
            .toList(),
        displayState: _displayState(searchResultState),
        onSearchRequest: (location) {
          store.dispatch(SearchServiceCiviqueAction(location: location));
        },
        onInputLocation: (input) => store.dispatch(SearchLocationRequestAction(input, villesOnly: true)),
        items: _items(searchResultState),
        displayLoaderAtBottomOfList: _displayLoader(searchResultState),
        onLoadMore: () => store.dispatch(RequestMoreServiceCiviqueSearchResultsAction()),
        filtresCount: _filtersCount(searchResultState),
        onRetry: () => store.dispatch(RetryServiceCiviqueSearchAction()));
  }

  @override
  List<Object?> get props => [locations, displayState, items, displayLoaderAtBottomOfList];

  static DisplayState _displayState(ServiceCiviqueSearchResultState state) {
    if (state is ServiceCiviqueSearchResultDataState) {
      return DisplayState.CONTENT;
    } else if (state is ServiceCiviqueSearchResultErrorState) {
      return DisplayState.FAILURE;
    } else {
      return DisplayState.LOADING;
    }
  }

  static bool _displayLoader(ServiceCiviqueSearchResultState resultsState) =>
      resultsState is ServiceCiviqueSearchResultDataState ? resultsState.isMoreDataAvailable : false;

  static List<ServiceCivique> _items(ServiceCiviqueSearchResultState resultsState) {
    return resultsState is ServiceCiviqueSearchResultDataState ? resultsState.offres : [];
  }
}

int? _filtersCount(ServiceCiviqueSearchResultState state) {
  if (state is ServiceCiviqueSearchResultDataState) {
    final SearchServiceCiviqueRequest lastRequest = state.lastRequest;
    int distanceCount = lastRequest.distance != null && lastRequest.distance != defaultDistanceValue ? 1 : 0;
    int startDateCount = lastRequest.startDate != null ? 1 : 0;
    int domainCount = lastRequest.domain != null && lastRequest.domain != Domain.values.first.tag ? 1 : 0;
    return distanceCount + startDateCount + domainCount;
  } else {
    return null;
  }
}
