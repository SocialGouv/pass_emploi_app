import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/location/search_location_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/list/offre_emploi_list_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_state.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

import 'location_view_model.dart';

class OffreEmploiSearchViewModel extends Equatable {
  final DisplayState displayState;
  final List<LocationViewModel> locations;
  final String errorMessage;
  final Function(String? input) onInputLocation;
  final Function(String keyWord, Location? location, bool onlyAlternance) onSearchingRequest;

  OffreEmploiSearchViewModel._({
    required this.displayState,
    required this.locations,
    required this.errorMessage,
    required this.onInputLocation,
    required this.onSearchingRequest,
  });

  factory OffreEmploiSearchViewModel.create(Store<AppState> store) {
    final searchState = store.state.offreEmploiSearchState;
    final searchResultsState = store.state.offreEmploiListState;
    return OffreEmploiSearchViewModel._(
      displayState: _displayState(searchState, searchResultsState),
      locations: store.state.searchLocationState.locations
          .map((location) => LocationViewModel.fromLocation(location))
          .toList(),
      errorMessage: _setErrorMessage(searchState, searchResultsState),
      onInputLocation: (input) => store.dispatch(SearchLocationRequestAction(input)),
      onSearchingRequest: (keywords, location, onlyAlternance) {
        return store.dispatch(
          OffreEmploiSearchRequestAction(keywords: keywords, location: location, onlyAlternance: onlyAlternance),
        );
      },
    );
  }

  @override
  List<Object?> get props => [displayState, errorMessage, locations];
}

String _setErrorMessage(OffreEmploiSearchState searchState, OffreEmploiListState searchResultsState) {
  return searchState is OffreEmploiSearchFailureState ? Strings.genericError : "";
}

DisplayState _displayState(OffreEmploiSearchState searchState, OffreEmploiListState searchResultsState) {
  if (searchState is OffreEmploiSearchSuccessState && searchResultsState is OffreEmploiListSuccessState) {
    return DisplayState.CONTENT;
  } else if (searchState is OffreEmploiSearchLoadingState) {
    return DisplayState.LOADING;
  } else {
    return DisplayState.FAILURE;
  }
}
