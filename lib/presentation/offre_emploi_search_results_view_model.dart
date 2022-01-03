import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:redux/redux.dart';

import 'offre_emploi_item_view_model.dart';

class OffreEmploiSearchResultsViewModel extends Equatable {
  final DisplayState displayState;
  final List<OffreEmploiItemViewModel> items;
  final bool displayLoaderAtBottomOfList;
  final int? filtresCount;
  final Function() onLoadMore;

  OffreEmploiSearchResultsViewModel({
    required this.displayState,
    required this.items,
    required this.displayLoaderAtBottomOfList,
    required this.filtresCount,
    required this.onLoadMore,
  });

  factory OffreEmploiSearchResultsViewModel.create(Store<AppState> store) {
    final searchState = store.state.offreEmploiSearchState;
    final searchResultsState = store.state.offreEmploiSearchResultsState;
    final searchParamsState = store.state.offreEmploiSearchParametersState;
    return OffreEmploiSearchResultsViewModel(
      displayState: _displayState(searchState, searchResultsState),
      items: _items(store.state.offreEmploiSearchResultsState),
      displayLoaderAtBottomOfList: _displayLoader(store.state.offreEmploiSearchResultsState),
      filtresCount: _filtresCount(searchParamsState),
      onLoadMore: () => store.dispatch(RequestMoreOffreEmploiSearchResultsAction()),
    );
  }

  @override
  List<Object?> get props => [displayState, items, displayLoaderAtBottomOfList, filtresCount];
}

int? _filtresCount(OffreEmploiSearchParametersState searchParamsState) {
  if (searchParamsState is OffreEmploiSearchParametersInitializedState) {
    final activeFiltresCount = _distanceCount(searchParamsState) + _otherFiltresCount(searchParamsState);
    if (activeFiltresCount == 0) {
      return null;
    } else {
      return activeFiltresCount;
    }
  } else {
    return null;
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

DisplayState _displayState(OffreEmploiSearchState searchState, OffreEmploiSearchResultsState searchResultsState) {
  if (searchState is OffreEmploiSearchSuccessState && searchResultsState is OffreEmploiSearchResultsDataState) {
    return DisplayState.CONTENT;
  } else if (searchState is OffreEmploiSearchLoadingState) {
    return DisplayState.LOADING;
  } else {
    return DisplayState.FAILURE;
  }
}


int _distanceCount(OffreEmploiSearchParametersInitializedState searchParamsState) {
  final distanceFiltre = searchParamsState.filtres.distance;
  return distanceFiltre != null && distanceFiltre != OffreEmploiSearchParametersFiltres.defaultDistanceValue ? 1 : 0;
}

int _otherFiltresCount(OffreEmploiSearchParametersInitializedState searchParamsState) {
  return [
    searchParamsState.filtres.experience,
    searchParamsState.filtres.contrat,
    searchParamsState.filtres.duree,
  ].where((element) {
    return element?.isNotEmpty ?? false;
  }).length;
}

