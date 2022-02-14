import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:redux/redux.dart';

import '../../redux/states/app_state.dart';

class SavedSearchListViewModel {
  final DisplayState displayState;
  final List savedSearch;

  SavedSearchListViewModel._(this.displayState, this.savedSearch);

  factory SavedSearchListViewModel.createFromStore(Store<AppState> store) {
    final state = store.state.savedSearchListState;
    if (state.isLoading()) return SavedSearchListViewModel._(DisplayState.LOADING, []);
    if (state.isFailure()) return SavedSearchListViewModel._(DisplayState.FAILURE, []);
    if (state.isSuccess()) return SavedSearchListViewModel._(DisplayState.CONTENT, state.getResultOrThrow());
    return SavedSearchListViewModel._(DisplayState.LOADING, []);
  }

  List<OffreEmploiSavedSearch> getOffresEmploi(bool withAlternance) {
    return savedSearch
        .whereType<OffreEmploiSavedSearch>()
        .where((element) => element.isAlternance == withAlternance)
        .toList();
  }

  List<ImmersionSavedSearch> getImmersions() {
    return savedSearch.whereType<ImmersionSavedSearch>().toList();
  }
}
