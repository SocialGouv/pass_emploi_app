import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/redux/middlewares/saved_search_middleware.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/saved_search_state.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_repository.dart';
import 'package:redux/redux.dart';

class ImmersionSavedSearchMiddleware extends SavedSearchMiddleware<ImmersionSavedSearch> {
  ImmersionSavedSearchMiddleware(SavedSearchRepository<ImmersionSavedSearch> repository) : super(repository);

  @override
  SavedSearchState<ImmersionSavedSearch> getSavedSearchState(Store<AppState> store) {
    return store.state.immersionSavedSearchState;
  }

  @override
  ImmersionSavedSearch copyWithTitle(ImmersionSavedSearch t, String title) => t.copyWithTitle(title);
}
