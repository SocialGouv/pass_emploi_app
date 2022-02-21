import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/redux/middlewares/saved_search_middleware.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/saved_search_state.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_repository.dart';
import 'package:redux/redux.dart';

class OffreEmploiSavedSearchMiddleware extends SavedSearchMiddleware<OffreEmploiSavedSearch> {
  OffreEmploiSavedSearchMiddleware(SavedSearchRepository<OffreEmploiSavedSearch> repository) : super(repository);

  @override
  SavedSearchState<OffreEmploiSavedSearch> getSavedSearchState(Store<AppState> store) {
    return store.state.offreEmploiSavedSearchState;
  }

  @override
  OffreEmploiSavedSearch copyWithTitle(OffreEmploiSavedSearch t, String title) => t.copyWithTitle(title);
}
