import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_middleware.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_state.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class OffreEmploiSavedSearchCreateMiddleware extends SavedSearchCreateMiddleware<OffreEmploiSavedSearch> {
  OffreEmploiSavedSearchCreateMiddleware(super.repository);

  @override
  SavedSearchCreateState<OffreEmploiSavedSearch> getSavedSearchCreateState(Store<AppState> store) {
    return store.state.offreEmploiSavedSearchCreateState;
  }

  @override
  OffreEmploiSavedSearch copyWithTitle(OffreEmploiSavedSearch t, String title) => t.copyWithTitle(title);
}
