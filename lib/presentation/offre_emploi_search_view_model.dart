import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/location/search_location_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/list/offre_emploi_list_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/list/offre_emploi_list_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/parameters/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_state.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class OffreEmploiSearchViewModel extends Equatable {
  final DisplayState searchDisplayState;
  final DisplayState resultDisplayState;
  final List<LocationViewModel> locations;
  final int nombreDeCriteres; //TODO: tests unitaires si on part sur cette solution
  final String errorMessage;
  final Function() onClearSearch;
  final Function(String? input) onInputLocation;
  final Function(String keyWord, Location? location, bool onlyAlternance) onSearchingRequest;
  final String selectedKeyWord;
  final Location? selectedLocation;

  OffreEmploiSearchViewModel._({
    required this.searchDisplayState,
    required this.resultDisplayState,
    required this.locations,
    required this.nombreDeCriteres,
    required this.errorMessage,
    required this.onClearSearch,
    required this.onInputLocation,
    required this.onSearchingRequest,
    required this.selectedKeyWord,
    required this.selectedLocation,
  });

  factory OffreEmploiSearchViewModel.create(Store<AppState> store) {
    final paramState = store.state.offreEmploiSearchParametersState;
    final searchState = store.state.offreEmploiSearchState;
    final searchResultsState = store.state.offreEmploiListState;
    return OffreEmploiSearchViewModel._(
      searchDisplayState: _searchDisplayState(searchState),
      resultDisplayState: _resultDisplayState(searchResultsState),
      locations: store.state.searchLocationState.locations
          .map((location) => LocationViewModel.fromLocation(location))
          .toList(),
      nombreDeCriteres: _nombreDeCriteres(paramState),
      errorMessage: _setErrorMessage(searchState, searchResultsState),
      onClearSearch: () => store.dispatch(OffreEmploiListResetAction()),
      onInputLocation: (input) => store.dispatch(SearchLocationRequestAction(input)),
      onSearchingRequest: (keywords, location, onlyAlternance) {
        return store.dispatch(
          OffreEmploiSearchRequestAction(keywords: keywords, location: location, onlyAlternance: onlyAlternance),
        );
      },
      selectedKeyWord: paramState is OffreEmploiSearchParametersInitializedState ? paramState.keywords : '',
      selectedLocation: paramState is OffreEmploiSearchParametersInitializedState ? paramState.location : null,
    );
  }

  @override
  List<Object?> get props => [
        searchDisplayState,
        resultDisplayState,
        errorMessage,
        locations,
        selectedKeyWord,
        selectedLocation,
      ];
}

int _nombreDeCriteres(OffreEmploiSearchParametersState paramState) {
  if (paramState is! OffreEmploiSearchParametersInitializedState) return 0;
  var count = 0;
  count += paramState.keywords.isNotEmpty ? 1 : 0;
  count += paramState.location != null ? 1 : 0;
  return count;
}

String _setErrorMessage(OffreEmploiSearchState searchState, OffreEmploiListState searchResultsState) {
  return searchState is OffreEmploiSearchFailureState ? Strings.genericError : "";
}

DisplayState _searchDisplayState(OffreEmploiSearchState searchState) {
  if (searchState is OffreEmploiSearchSuccessState) {
    return DisplayState.CONTENT;
  } else if (searchState is OffreEmploiSearchLoadingState) {
    return DisplayState.LOADING;
  } else if (searchState is OffreEmploiSearchFailureState) {
    return DisplayState.FAILURE;
  } else {
    return DisplayState.EMPTY;
  }
}

// TODO TU ? Si on garde cette logique
DisplayState _resultDisplayState(OffreEmploiListState resultState) {
  if (resultState is OffreEmploiListSuccessState) {
    return DisplayState.CONTENT;
  } else {
    return DisplayState.FAILURE;
  }
}
