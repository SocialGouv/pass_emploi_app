import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_actions.dart';
import 'package:pass_emploi_app/features/saved_search/init/saved_search_initialize_action.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

import '../../../models/saved_search/saved_search_extractors.dart';

class SavedSearchInitializeMiddleware extends MiddlewareClass<AppState> {
  @override
  call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
    final loginState = store.state.loginState;
    if (action is SaveSearchInitializeAction<OffreEmploiSavedSearch> && loginState is LoginSuccessState) {
      final OffreEmploiSavedSearch search = OffreEmploiSearchExtractor().getSearchFilters(store);
      store.dispatch(SavedSearchCreateInitializeAction<OffreEmploiSavedSearch>(search));
    } else if (action is SaveSearchInitializeAction<ImmersionSavedSearch> && loginState is LoginSuccessState) {
      final ImmersionSavedSearch search = ImmersionSearchExtractor().getSearchFilters(store);
      store.dispatch(SavedSearchCreateInitializeAction<ImmersionSavedSearch>(search));
    }
  }
}
