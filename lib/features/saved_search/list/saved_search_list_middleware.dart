import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/accepter/accepter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searches_repository.dart';
import 'package:redux/redux.dart';

class SavedSearchListMiddleware extends MiddlewareClass<AppState> {
  final GetSavedSearchRepository _repository;

  SavedSearchListMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final userId = store.state.userId();
    if (userId == null) return;

    if (action is SavedSearchListRequestAction) {
      await _fetchSavedSearch(store, userId);
    } else if (action is AccepterSuggestionRechercheSuccessAction) {
      await _fetchSavedSearch(store, userId);
    }
  }

  Future<void> _fetchSavedSearch(Store<AppState> store, String userId) async {
    store.dispatch(SavedSearchListLoadingAction());
    final savedSearches = await _repository.getSavedSearch(userId);
    store.dispatch(
      savedSearches != null ? SavedSearchListSuccessAction(savedSearches) : SavedSearchListFailureAction(),
    );
  }
}
