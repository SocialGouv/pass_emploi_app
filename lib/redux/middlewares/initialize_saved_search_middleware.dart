import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/redux/actions/saved_search_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

import '../../models/saved_search/saved_search_extractors.dart';

class InitializeSavedSearchMiddleware extends MiddlewareClass<AppState> {
  @override
  call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
    final loginState = store.state.loginState;
    if (action is InitializeSaveSearchAction<OffreEmploiSavedSearch> && loginState.isSuccess()) {
      final OffreEmploiSavedSearch search = OffreEmploiSearchExtractor().getSearchFilters(store);
      store.dispatch(CreateSavedSearchAction<OffreEmploiSavedSearch>(search));
    } else if (action is InitializeSaveSearchAction<ImmersionSavedSearch> && loginState.isSuccess()) {
      final ImmersionSavedSearch search = ImmersionSearchExtractor().getSearchFilters(store);
      store.dispatch(CreateSavedSearchAction<ImmersionSavedSearch>(search));
    }
  }
}
