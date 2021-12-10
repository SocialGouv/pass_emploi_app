import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pass_emploi_app/models/department.dart';
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
  final Function(String? input) onInputLocation;
  final List<Department> departments;
  final Function(String keyWord, String department) searchingRequest;
  final Function() getLocations;
  final String errorMessage;

  OffreEmploiSearchViewModel._({
    required this.displayState,
    required this.departments,
    required this.searchingRequest,
    required this.errorMessage,
    required this.onInputLocation,
    required this.getLocations,
  });

  factory OffreEmploiSearchViewModel.create(Store<AppState> store) {
    final searchState = store.state.offreEmploiSearchState;
    final searchResultsState = store.state.offreEmploiSearchResultsState;
    return OffreEmploiSearchViewModel._(
      displayState: _displayState(searchState, searchResultsState),
      searchingRequest: (keyWord, location) => _searchingRequest(store, keyWord, location),
      getLocations: () => store.state.searchLocationState.locations,
      departments: Department.values,
      onInputLocation: (input) => store.dispatch(RequestLocationAction(input)),
      errorMessage: _setErrorMessage(searchState, searchResultsState),
    );
  }


  List<Department> filterDepartments(String userInput) {
    if (userInput.length < 2 || userInput.isEmpty) return [];
    return departments.where((department) {
      return sanitizeString(department.name).contains(sanitizeString(userInput));
    }).toList();
  }

  String sanitizeString(String str) {
    return removeDiacritics(str).replaceAll(RegExp("[-'`]"), " ").trim().toUpperCase();
  }

  String removeDiacritics(String str) {
    var withDia = 'ÀÁÂÃÄàáâäÒÓÔÕÕÖòóôõöÈÉÊËèéêëÇçÌÍÎÏìíîïÙÚÛÜùúûü';
    var withoutDia = 'AAAAAaaaaOOOOOOoooooEEEEeeeeCcIIIIiiiiUUUUuuuu';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;
  }

  @override
  List<Object?> get props => [displayState, errorMessage];
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
