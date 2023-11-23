import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_middleware.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_state.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ImmersionSavedSearchCreateMiddleware extends SavedSearchCreateMiddleware<ImmersionSavedSearch> {
  ImmersionSavedSearchCreateMiddleware(super.repository);

  @override
  SavedSearchCreateState<ImmersionSavedSearch> getSavedSearchCreateState(Store<AppState> store) {
    return store.state.immersionSavedSearchCreateState;
  }

  @override
  ImmersionSavedSearch copyWithTitle(ImmersionSavedSearch t, String title) => t.copyWithTitle(title);
}
