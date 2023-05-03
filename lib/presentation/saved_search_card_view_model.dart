import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/saved_search/get/saved_search_get_action.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class SavedSearchCardViewModel extends Equatable {
  final Function(SavedSearch) fetchSavedSearchResult;

  SavedSearchCardViewModel({
    required this.fetchSavedSearchResult,
  });

  static SavedSearchCardViewModel create(Store<AppState> store) {
    return SavedSearchCardViewModel(
      fetchSavedSearchResult: (savedSearch) => store.dispatch(FetchSavedSearchResultsAction(savedSearch)),
    );
  }

  @override
  List<Object?> get props => [];
}
