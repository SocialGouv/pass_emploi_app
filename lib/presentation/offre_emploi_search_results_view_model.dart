import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

import 'offre_emploi_item_view_model.dart';

class OffreEmploiSearchResultsViewModel extends Equatable {
  final DisplayState displayState;
  final List<OffreEmploiItemViewModel> items;
  final bool displayLoaderAtBottomOfList;
  final bool withFiltreButton;
  final int? filtresCount;
  final String errorMessage;
  final Function() onLoadMore;

  OffreEmploiSearchResultsViewModel({
    required this.displayState,
    required this.items,
    required this.displayLoaderAtBottomOfList,
    required this.withFiltreButton,
    required this.filtresCount,
    required this.errorMessage,
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
      withFiltreButton: _withFilterButton(searchParamsState),
      filtresCount: _filtresCount(searchParamsState),
      errorMessage: _errorMessage(searchState, searchResultsState),
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
      ? resultsState.offres.map((e) => OffreEmploiItemViewModel.create(e)).toList()
      : [];
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

int _distanceCount(OffreEmploiSearchParametersInitializedState searchParamsState) {
  final distanceFiltre = searchParamsState.filtres.distance;
  return distanceFiltre != null && distanceFiltre != OffreEmploiSearchParametersFiltres.defaultDistanceValue ? 1 : 0;
}

int _otherFiltresCount(OffreEmploiSearchParametersInitializedState searchParamsState) {
  return [
    searchParamsState.filtres.experience?.length ?? 0,
    searchParamsState.filtres.contrat?.length ?? 0,
    searchParamsState.filtres.duree?.length ?? 0,
  ].fold(0, (previousValue, element) => previousValue + element);
}

String _errorMessage(OffreEmploiSearchState searchState, OffreEmploiSearchResultsState searchResultsState) {
  return searchState is OffreEmploiSearchFailureState ? Strings.genericError : "";
}

bool _withFilterButton(OffreEmploiSearchParametersState state) {
  if (state is OffreEmploiSearchParametersInitializedState && state.onlyAlternance) {
    return state.location?.type == LocationType.COMMUNE;
  }
  return true;
}
