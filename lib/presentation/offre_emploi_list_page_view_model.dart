import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:redux/redux.dart';

enum OffreEmploiListDisplayState { SHOW_CONTENT, SHOW_LOADER, SHOW_ERROR, SHOW_EMPTY_ERROR }

class OffreEmploiListPageViewModel {
  final OffreEmploiListDisplayState displayState;
  final List<OffreEmploiItemViewModel> items;

  OffreEmploiListPageViewModel._(this.displayState, this.items);

  factory OffreEmploiListPageViewModel.create(Store<AppState> store) {
    final searchState = store.state.offreEmploiSearchState;
    return OffreEmploiListPageViewModel._(
      _displayState(searchState),
      _items(searchState),
    );
  }
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
