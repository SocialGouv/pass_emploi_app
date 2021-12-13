import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/actions/search_location_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

enum OffreEmploiSearchDisplayState { SHOW_CONTENT, SHOW_LOADER, SHOW_ERROR, SHOW_EMPTY_ERROR }

class OffreEmploiSearchViewModel extends Equatable {
  final OffreEmploiSearchDisplayState displayState;
  final List<Location> locations;
  final String errorMessage;
  final Function(String? input) onInputLocation;
  final Function(String keyWord, String department) searchingRequest;

  OffreEmploiSearchViewModel._({
    required this.displayState,
    required this.locations,
    required this.errorMessage,
    required this.onInputLocation,
    required this.searchingRequest,
  });

  factory OffreEmploiSearchViewModel.create(Store<AppState> store) {
    final searchState = store.state.offreEmploiSearchState;
    final searchResultsState = store.state.offreEmploiSearchResultsState;
    return OffreEmploiSearchViewModel._(
      displayState: _displayState(searchState, searchResultsState),
      locations: store.state.searchLocationState.locations,
      errorMessage: _setErrorMessage(searchState, searchResultsState),
      onInputLocation: (input) => store.dispatch(RequestLocationAction(input)),
      searchingRequest: (keyWord, location) => _searchingRequest(store, keyWord, location),
    );
  }

  @override
  List<Object?> get props => [displayState, errorMessage, locations];
}

void _searchingRequest(Store<AppState> store, String keyWord, String location) {
  store.dispatch(SearchOffreEmploiAction(keywords: keyWord, department: location));
}

String _setErrorMessage(OffreEmploiSearchState searchState, OffreEmploiSearchResultsState searchResultsState) {
  if (searchState is OffreEmploiSearchSuccessState && searchResultsState is OffreEmploiSearchResultsDataState) {
    return searchResultsState.offres.isNotEmpty ? "" : Strings.noContentError;
  } else if (searchState is OffreEmploiSearchFailureState) {
    return Strings.genericError;
  } else {
    return "";
  }
}

OffreEmploiSearchDisplayState _displayState(
    OffreEmploiSearchState searchState, OffreEmploiSearchResultsState searchResultsState) {
  if (searchState is OffreEmploiSearchSuccessState && searchResultsState is OffreEmploiSearchResultsDataState) {
    return searchResultsState.offres.isNotEmpty
        ? OffreEmploiSearchDisplayState.SHOW_CONTENT
        : OffreEmploiSearchDisplayState.SHOW_EMPTY_ERROR;
  } else if (searchState is OffreEmploiSearchLoadingState) {
    return OffreEmploiSearchDisplayState.SHOW_LOADER;
  } else {
    return OffreEmploiSearchDisplayState.SHOW_ERROR;
  }
}
