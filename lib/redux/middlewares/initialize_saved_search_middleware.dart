import 'package:pass_emploi_app/features/login/login_state.dart';
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
    if (action is InitializeSaveSearchAction<OffreEmploiSavedSearch> && loginState is LoginSuccessState) {
      final OffreEmploiSavedSearch search = OffreEmploiSearchExtractor().getSearchFilters(store);
      store.dispatch(CreateSavedSearchAction<OffreEmploiSavedSearch>(search));
    } else if (action is InitializeSaveSearchAction<ImmersionSavedSearch> && loginState is LoginSuccessState) {
      final ImmersionSavedSearch search = ImmersionSearchExtractor().getSearchFilters(store);
      store.dispatch(CreateSavedSearchAction<ImmersionSavedSearch>(search));
    }
  }
}
