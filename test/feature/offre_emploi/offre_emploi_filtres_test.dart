import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/offre_emploi/list/offre_emploi_list_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/parameters/offre_emploi_search_parameters_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/parameters/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_state.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:redux/src/store.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../utils/test_setup.dart';

main() {
  test("applying new filtres when call succeeds should replace all existing data and filtres should be stored",
      () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    final repositoryMock = OffreEmploiRepositorySuccessWithMoreDataMock();
    testStoreFactory.offreEmploiRepository = repositoryMock;
    final store = _initializeReduxStore(testStoreFactory);

    final displayedLoading =
        store.onChange.any((element) => element.offreEmploiSearchState is OffreEmploiSearchLoadingState);
    final successState =
        store.onChange.firstWhere((element) => element.offreEmploiSearchState is OffreEmploiSearchSuccessState);

    // When
    store.dispatch(OffreEmploiSearchParametersUpdateFiltresRequestAction(
        OffreEmploiSearchParametersFiltres.withFiltres(distance: 40)));

    // Then
    expect(await displayedLoading, true);
    final appState = await successState;
    expect(appState.offreEmploiSearchState is OffreEmploiSearchSuccessState, true);

    final searchResultsState = (appState.offreEmploiListState as OffreEmploiListSuccessState);
    expect(searchResultsState.offres.length, 3);
    expect(searchResultsState.loadedPage, 1);

    final paramsState = (appState.offreEmploiSearchParametersState as OffreEmploiSearchParametersInitializedState);
    expect(paramsState.filtres.distance, 40);

    expect(repositoryMock.wasCalledWithFiltres, isTrue);
  });

  test("applying new filtres when call fails should erase existing data and filtres should be erased", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.offreEmploiRepository = OffreEmploiRepositoryFailureStub();
    final store = _initializeReduxStore(testStoreFactory);

    final displayedLoading =
        store.onChange.any((element) => element.offreEmploiSearchState is OffreEmploiSearchLoadingState);
    final failureState =
        store.onChange.firstWhere((element) => element.offreEmploiSearchState is OffreEmploiSearchFailureState);

    // When
    store.dispatch(
      OffreEmploiSearchParametersUpdateFiltresRequestAction(
        OffreEmploiSearchParametersFiltres.withFiltres(
          distance: 40,
          duree: [DureeFiltre.temps_plein],
          contrat: [ContratFiltre.cdi],
          experience: [ExperienceFiltre.de_un_a_trois_ans],
        ),
      ),
    );

    // Then
    expect(await displayedLoading, true);
    final appState = await failureState;
    expect(appState.offreEmploiSearchState is OffreEmploiSearchFailureState, true);

    final parametersState = appState.offreEmploiSearchParametersState as OffreEmploiSearchParametersInitializedState;
    expect(parametersState.filtres.distance, null);
    expect(parametersState.filtres.duree, null);
    expect(parametersState.filtres.contrat, null);
    expect(parametersState.filtres.experience, null);
  });
}

Store<AppState> _initializeReduxStore(TestStoreFactory testStoreFactory) {
  return testStoreFactory.initializeReduxStore(
    initialState: loggedInState().copyWith(
      offreEmploiListState: _pageOneLoadedAndMoreDataAvailable(),
      offreEmploiSearchParametersState: OffreEmploiSearchParametersInitializedState(
        keywords: "boulanger patissier",
        location: null,
        onlyAlternance: false,
        filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
      ),
    ),
  );
}

OffreEmploiListState _pageOneLoadedAndMoreDataAvailable() {
  return OffreEmploiListState.data(
    offres: [mockOffreEmploi()],
    loadedPage: 1,
    isMoreDataAvailable: true,
  );
}

class OffreEmploiRepositorySuccessWithMoreDataMock extends OffreEmploiRepository {
  OffreEmploiRepositorySuccessWithMoreDataMock() : super("", DummyHttpClient(), DummyHeadersBuilder());

  bool wasCalledWithFiltres = false;

  @override
  Future<OffreEmploiSearchResponse?> search({required String userId, required SearchOffreEmploiRequest request}) async {
    if (request.filtres.distance == 40) {
      wasCalledWithFiltres = true;
    }
    return OffreEmploiSearchResponse(isMoreDataAvailable: true, offres: [
      mockOffreEmploi(),
      mockOffreEmploi(),
      mockOffreEmploi(),
    ]);
  }
}
