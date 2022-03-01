import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/service_civique/search/search_service_civique_actions.dart';
import 'package:pass_emploi_app/features/service_civique/search/service_civique_search_result_state.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:redux/redux.dart';

import '../features/service_civique/search/search_service_civique_actions.dart';
import '../models/service_civique.dart';
import '../redux/actions/search_location_action.dart';
import '../redux/states/app_state.dart';

class ServiceCiviqueViewModel extends Equatable {
  final List<LocationViewModel> locations;
  final Function(Location? location) onSearchRequest;
  final Function(String? input) onInputLocation;
  final DisplayState displayState;
  final Function() onLoadMore;
  final Function() onRetry;
  final List<ServiceCivique> items;
  final bool displayLoaderAtBottomOfList;

  ServiceCiviqueViewModel._({
    required this.locations,
    required this.onSearchRequest,
    required this.onInputLocation,
    required this.displayState,
    required this.onLoadMore,
    required this.items,
    required this.displayLoaderAtBottomOfList,
    required this.onRetry,
  });

  factory ServiceCiviqueViewModel.create(Store<AppState> store) {
    return ServiceCiviqueViewModel._(
      locations: store.state.searchLocationState.locations
          .map((location) => LocationViewModel.fromLocation(location))
          .toList(),
      displayState: _displayState(store.state.serviceCiviqueSearchResultState),
      onSearchRequest: (location) {
        store.dispatch(SearchServiceCiviqueAction(location: location));
      },
      onInputLocation: (input) => store.dispatch(RequestLocationAction(input, villesOnly: true)),
      items: _items(store.state.serviceCiviqueSearchResultState),
      displayLoaderAtBottomOfList: _displayLoader(store.state.serviceCiviqueSearchResultState),
      onLoadMore: () => store.dispatch(RequestMoreServiceCiviqueSearchResultsAction()),
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
