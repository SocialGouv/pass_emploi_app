import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_middleware.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_state.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_repository.dart';
import 'package:redux/src/store.dart';

class ServiceCiviqueSavedSearchCreateMiddleware extends SavedSearchCreateMiddleware<ServiceCiviqueSavedSearch> {
  ServiceCiviqueSavedSearchCreateMiddleware(SavedSearchRepository<ServiceCiviqueSavedSearch> repository) : super(repository);

  @override
  SavedSearchCreateState<ServiceCiviqueSavedSearch> getSavedSearchCreateState(Store<AppState> store) {
    return store.state.serviceCiviqueSavedSearchCreateState;
  }

  @override
  ServiceCiviqueSavedSearch copyWithTitle(ServiceCiviqueSavedSearch t, String title) => t.copyWithTitle(title);
}