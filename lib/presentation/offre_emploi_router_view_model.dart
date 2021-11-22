import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:redux/redux.dart';

enum OffreEmploiRouterDisplayState {
  SHOW_SEARCH,
  SHOW_LIST,
}

class OffreEmploiRouterViewModel extends Equatable {
  final OffreEmploiRouterDisplayState displayState;

  OffreEmploiRouterViewModel._(this.displayState);

  factory OffreEmploiRouterViewModel.create(Store<AppState> store) {
    return OffreEmploiRouterViewModel._(_displayState(store));
  }

  @override
  List<Object?> get props => [displayState];
}

OffreEmploiRouterDisplayState _displayState(Store<AppState> store) {
  var resultsState = store.state.offreEmploiSearchResultsState;
  if (resultsState is OffreEmploiSearchResultsDataState) {
    if (resultsState.offres.isEmpty) {
      return OffreEmploiRouterDisplayState.SHOW_SEARCH;
    } else {
      return OffreEmploiRouterDisplayState.SHOW_LIST;
    }
  } else {
    return OffreEmploiRouterDisplayState.SHOW_SEARCH;
  }
}
