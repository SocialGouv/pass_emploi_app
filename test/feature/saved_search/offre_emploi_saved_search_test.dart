import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/redux/actions/saved_search_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/saved_search_state.dart';
import 'package:pass_emploi_app/repositories/saved_search/offre_emploi_saved_search_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../utils/test_setup.dart';

main() {
  test("savedSearch should be updated when savedSearch is added and api call succeeds", () async {
    // Given
    var offreEmploiSavedSearch = OffreEmploiSavedSearch(
        title: "Titre de l'offre",
        filters: OffreEmploiSearchParametersFiltres.noFiltres(),
        keywords: "Boulanger",
        isAlternance: false,
        location: mockLocation(),
        metier: "Boulanger");
    AppState initialState = AppState.initialState().copyWith(
      offreEmploiSavedSearchState: SavedSearchState.initialized(offreEmploiSavedSearch),
      loginState: successMiloUserState(),
    );
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.offreEmploiSavedSearchRepository = OffreEmploiSavedSearchRepositorySuccessStub();
    testStoreFactory.authenticator = AuthenticatorLoggedInStub();
    final store = testStoreFactory.initializeReduxStore(initialState: initialState);
    final expected =
        store.onChange.firstWhere((element) => element.offreEmploiSavedSearchState.status == SavedSearchStatus.SUCCESS);

    // When
    store.dispatch(RequestPostSavedSearchAction(offreEmploiSavedSearch));

    // Then
    var offreEmploiSavedSearchState = (await expected).offreEmploiSavedSearchState;
    expect(offreEmploiSavedSearchState is SavedSearchSuccessfullyCreated, true);
  });

  test("savedSearch state should not be updated when savedSearch is added and api call fails", ()  {
    // Given

    // When


    // Then
  });
  
}

class OffreEmploiSavedSearchRepositorySuccessStub extends OffreEmploiSavedSearchRepository {
  OffreEmploiSavedSearchRepositorySuccessStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<bool> postSavedSearch(String userId, OffreEmploiSavedSearch savedSearch) async {
    return true;
  }
}