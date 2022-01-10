import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/actions/search_location_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
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
    final searchResultsState = store.state.offreEmploiSearchResultsState;
    return OffreEmploiSearchViewModel._(
      displayState: _displayState(searchState, searchResultsState),
      locations: store.state.searchLocationState.locations
          .map((location) => LocationViewModel.fromLocation(location))
          .toList(),
      errorMessage: _setErrorMessage(searchState, searchResultsState),
      onInputLocation: (input) => store.dispatch(RequestLocationAction(input)),
      onSearchingRequest: (keywords, location, onlyAlternance) {
        return store.dispatch(
          SearchOffreEmploiAction(keywords: keywords, location: location, onlyAlternance: onlyAlternance),
        );
      },
    );
  }

  @override
  List<Object?> get props => [displayState, errorMessage, locations];
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

DisplayState _displayState(OffreEmploiSearchState searchState, OffreEmploiSearchResultsState searchResultsState) {
  if (searchState is OffreEmploiSearchSuccessState && searchResultsState is OffreEmploiSearchResultsDataState) {
    return searchResultsState.offres.isNotEmpty ? DisplayState.CONTENT : DisplayState.EMPTY;
  } else if (searchState is OffreEmploiSearchLoadingState) {
    return DisplayState.LOADING;
  } else {
    return DisplayState.FAILURE;
  }
}
