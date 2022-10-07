import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/saved_search/get/saved_search_get_action.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_list_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searches_repository.dart';
import 'package:redux/redux.dart';

class SavedSearchGetMiddleware extends MiddlewareClass<AppState> {
  final GetSavedSearchRepository _repository;

  SavedSearchGetMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is SavedSearchGetAction && loginState is LoginSuccessState) {
      final search = (await _repository.getSavedSearch(loginState.user.id))
          ?.where((e) => e.getId() == action.savedSearchId)
          .firstOrNull;
      if (search != null) SavedSearchListViewModel.dispatchSearchRequest(search, store);
    }
  }
}
