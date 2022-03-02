import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/actions/saved_search_actions.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searchs_repository.dart';
import 'package:redux/redux.dart';

import '../../../models/saved_search/immersion_saved_search.dart';
import '../../../models/saved_search/offre_emploi_saved_search.dart';
import '../../../presentation/saved_search/saved_search_list_view_model.dart';
import '../../states/app_state.dart';

class GetSavedSearchMiddleware extends MiddlewareClass<AppState> {
  final GetSavedSearchRepository _repository;

  GetSavedSearchMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is GetSavedSearchAction && loginState is LoginSuccessState) {
      final search = (await _repository.getSavedSearch(loginState.user.id))
          ?.where((e) => e.getId() == action.savedSearchId)
          .firstOrNull;
      if (search is ImmersionSavedSearch) {
        SavedSearchListViewModel.onOffreImmersionSelected(search, store);
      } else if (search is OffreEmploiSavedSearch) {
        SavedSearchListViewModel.onOffreEmploiSelected(search, store);
      }
    }
  }
}
