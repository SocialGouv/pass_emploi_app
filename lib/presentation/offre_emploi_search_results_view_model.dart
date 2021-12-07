import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:redux/redux.dart';

import 'offre_emploi_item_view_model.dart';

enum OffreEmploiSearchResultsDisplayState { SHOW_CONTENT, SHOW_LOADER, SHOW_ERROR }

class OffreEmploiSearchResultsViewModel {
  final OffreEmploiSearchResultsDisplayState displayState;
  final List<OffreEmploiItemViewModel> items;
  final bool displayLoaderAtBottomOfList;
  final Function() onLoadMore;

  OffreEmploiSearchResultsViewModel({
    required this.displayState,
    required this.items,
    required this.displayLoaderAtBottomOfList,
    required this.onLoadMore,
  });

  factory OffreEmploiSearchResultsViewModel.create(Store<AppState> store) {
    final searchState = store.state.offreEmploiSearchState;
    final searchResultsState = store.state.offreEmploiSearchResultsState;
    return OffreEmploiSearchResultsViewModel(
      displayState: _displayState(searchState, searchResultsState),
      items: _items(store.state.offreEmploiSearchResultsState),
      displayLoaderAtBottomOfList: _displayLoader(store.state.offreEmploiSearchResultsState),
      onLoadMore: () => store.dispatch(RequestMoreOffreEmploiSearchResultsAction()),
    );
  }
}

_displayLoader(OffreEmploiSearchResultsState resultsState) =>
    resultsState is OffreEmploiSearchResultsDataState ? resultsState.isMoreDataAvailable : false;

List<OffreEmploiItemViewModel> _items(OffreEmploiSearchResultsState resultsState) {
  return resultsState is OffreEmploiSearchResultsDataState
      ? resultsState.offres
          .map((e) => OffreEmploiItemViewModel(
                e.id,
                e.title,
                e.companyName,
                e.contractType,
                e.duration,
                e.location,
              ))
          .toList()
      : [];
}

OffreEmploiSearchResultsDisplayState _displayState(
    OffreEmploiSearchState searchState, OffreEmploiSearchResultsState searchResultsState) {
  if (searchState is OffreEmploiSearchSuccessState && searchResultsState is OffreEmploiSearchResultsDataState) {
    return OffreEmploiSearchResultsDisplayState.SHOW_CONTENT;
  } else if (searchState is OffreEmploiSearchLoadingState) {
    return OffreEmploiSearchResultsDisplayState.SHOW_LOADER;
  } else {
    return OffreEmploiSearchResultsDisplayState.SHOW_ERROR;
  }
}
