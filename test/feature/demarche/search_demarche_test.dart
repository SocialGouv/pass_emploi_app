import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/repositories/demarche/search_demarche_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

void main() {
  test('Demarches du référentiel should be searched and displayed when screen loads', () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.searchDemarcheRepository = DemarcheDuReferentielSuccessStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInPoleEmploiState());

    final displayedLoading = store.onChange.any((e) => e.searchDemarcheState is SearchDemarcheLoadingState);
    final successAppState = store.onChange.firstWhere((e) => e.searchDemarcheState is SearchDemarcheSuccessState);

    // When
    await store.dispatch(SearchDemarcheRequestAction('query'));

    // Then
    expect(await displayedLoading, true);
    final appState = await successAppState;
    expect(appState.searchDemarcheState, isA<SearchDemarcheSuccessState>());
    expect(
      (appState.searchDemarcheState as SearchDemarcheSuccessState).demarchesDuReferentiel,
      [mockDemarcheDuReferentiel('quoi1')],
    );
  });

  test('Search should display an error when fetching failed', () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.searchDemarcheRepository = DemarcheDuReferentielFailureStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInPoleEmploiState());

    final displayedLoading = store.onChange.any((e) => e.searchDemarcheState is SearchDemarcheLoadingState);
    final successAppState = store.onChange.firstWhere((e) => e.searchDemarcheState is SearchDemarcheFailureState);

    // When
    await store.dispatch(SearchDemarcheRequestAction('query'));

    // Then
    expect(await displayedLoading, true);
    final appState = await successAppState;
    expect(appState.searchDemarcheState, isA<SearchDemarcheFailureState>());
  });

  test('Reset', () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.searchDemarcheRepository = DemarcheDuReferentielFailureStub();
    final store = testStoreFactory.initializeReduxStore(
      initialState: loggedInPoleEmploiState().copyWith(
        searchDemarcheState: SearchDemarcheSuccessState([mockDemarcheDuReferentiel('quoi')]),
      ),
    );

    // When
    await store.dispatch(SearchDemarcheResetAction());

    // Then
    expect(store.state.searchDemarcheState, isA<SearchDemarcheNotInitializedState>());
  });
}

class DemarcheDuReferentielSuccessStub extends SearchDemarcheRepository {
  DemarcheDuReferentielSuccessStub() : super('', DummyHttpClient());

  @override
  Future<List<DemarcheDuReferentiel>?> search(String query) async {
    if (query == 'query') return [mockDemarcheDuReferentiel('quoi1')];
    return null;
  }
}

class DemarcheDuReferentielFailureStub extends SearchDemarcheRepository {
  DemarcheDuReferentielFailureStub() : super('', DummyHttpClient());

  @override
  Future<List<DemarcheDuReferentiel>?> search(String query) async => null;
}
