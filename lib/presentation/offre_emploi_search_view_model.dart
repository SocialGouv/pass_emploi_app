import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/department.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

enum OffreEmploiSearchDisplayState { SHOW_CONTENT, SHOW_LOADER, SHOW_ERROR, SHOW_EMPTY_ERROR }

class OffreEmploiSearchViewModel {
  final OffreEmploiSearchDisplayState displayState;
  final List<Department> departments;
  final Function(String keyWord, String department) searchingRequest;
  final String errorMessage;

  OffreEmploiSearchViewModel._({
    required this.displayState,
    required this.departments,
    required this.searchingRequest,
    this.errorMessage = "",
  });

  factory OffreEmploiSearchViewModel.create(Store<AppState> store) {
    final searchState = store.state.offreEmploiSearchState;
    return OffreEmploiSearchViewModel._(
      displayState: _displayState(searchState),
      searchingRequest: (keyWord, department) => _searchingRequest(store, keyWord, department),
      departments: Department.values,
      errorMessage: _setErrorMessage(searchState),
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
}

void _searchingRequest(Store<AppState> store, String keyWord, String department) {
  store.dispatch(SearchOffreEmploiAction(keywords: keyWord, department: department));
}

String _setErrorMessage(OffreEmploiSearchState searchState) {
  if (searchState is OffreEmploiSearchSuccessState) {
    return searchState.offres.isNotEmpty ? "" : Strings.noContentError;
  } else if (searchState is OffreEmploiSearchFailureState) {
    return Strings.genericError;
  }
  return "";
}

OffreEmploiSearchDisplayState _displayState(OffreEmploiSearchState searchState) {
  if (searchState is OffreEmploiSearchSuccessState) {
    return searchState.offres.isNotEmpty
        ? OffreEmploiSearchDisplayState.SHOW_CONTENT
        : OffreEmploiSearchDisplayState.SHOW_EMPTY_ERROR;
  } else if (searchState is OffreEmploiSearchLoadingState) {
    return OffreEmploiSearchDisplayState.SHOW_LOADER;
  } else {
    return OffreEmploiSearchDisplayState.SHOW_ERROR;
  }
}
