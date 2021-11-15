import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/department.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:redux/redux.dart';

enum OffreEmploiListDisplayState { SHOW_CONTENT, SHOW_LOADER, SHOW_ERROR, SHOW_EMPTY_ERROR }

class OffreEmploiListPageViewModel {
  final OffreEmploiListDisplayState displayState;
  final List<OffreEmploiItemViewModel> items;
  final List<Department> departments;
  final Function(String keyWord, String department) searchingRequest;

  OffreEmploiListPageViewModel._({required this.displayState, required this.items, required this.departments, required this.searchingRequest});

  factory OffreEmploiListPageViewModel.create(Store<AppState> store) {
    final searchState = store.state.offreEmploiSearchState;
    return OffreEmploiListPageViewModel._(
      displayState: _displayState(searchState),
      items: _items(searchState),
      searchingRequest: (keyWord, department) => _searchingRequest(store, keyWord, department),
      departments: Department.values,
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

OffreEmploiListDisplayState _displayState(OffreEmploiSearchState searchState) {
  if (searchState is OffreEmploiSearchSuccessState) {
    return searchState.offres.isNotEmpty
        ? OffreEmploiListDisplayState.SHOW_CONTENT
        : OffreEmploiListDisplayState.SHOW_EMPTY_ERROR;
  } else if (searchState is OffreEmploiSearchLoadingState) {
    return OffreEmploiListDisplayState.SHOW_LOADER;
  } else {
    return OffreEmploiListDisplayState.SHOW_ERROR;
  }
}

List<OffreEmploiItemViewModel> _items(OffreEmploiSearchState searchState) {
  return searchState is OffreEmploiSearchSuccessState
      ? searchState.offres
          .map((e) => OffreEmploiItemViewModel(
                e.id,
                e.title,
                e.companyName,
                e.contractType,
                e.location,
              ))
          .toList()
      : [];
}

class OffreEmploiItemViewModel extends Equatable {
  final String id;
  final String title;
  final String? companyName;
  final String contractType;
  final String location;

  OffreEmploiItemViewModel(this.id, this.title, this.companyName, this.contractType, this.location);

  @override
  List<Object?> get props => [
        id,
        title,
        companyName,
        contractType,
        location,
      ];
}
