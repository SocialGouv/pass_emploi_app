import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/repositories/demarche/search_demarche_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test('Demarches du référentiel should be searched and displayed when screen loads', () async {
    // Given
    final store = givenState()
        .loggedIn()
        .store((factory) => {factory.searchDemarcheRepository = DemarcheDuReferentielSuccessStub()});
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
      [mockDemarcheDuReferentiel()],
    );
  });

  test('Search should display an error when fetching failed', () async {
    // Given
    final store = givenState()
        .loggedIn()
        .store((factory) => {factory.searchDemarcheRepository = DemarcheDuReferentielFailureStub()});
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
    final store = givenState() //
        .loggedIn() //
        .searchDemarchesSuccess([mockDemarcheDuReferentiel()]) //
        .store();

    // When
    await store.dispatch(SearchDemarcheResetAction());

    // Then
    expect(store.state.searchDemarcheState, isA<SearchDemarcheNotInitializedState>());
  });
}

class DemarcheDuReferentielSuccessStub extends SearchDemarcheRepository {
  DemarcheDuReferentielSuccessStub() : super(DioMock());

  @override
  Future<List<DemarcheDuReferentiel>?> search(String query) async {
    if (query == 'query') return [mockDemarcheDuReferentiel()];
    return null;
  }
}

class DemarcheDuReferentielFailureStub extends SearchDemarcheRepository {
  DemarcheDuReferentielFailureStub() : super(DioMock());

  @override
  Future<List<DemarcheDuReferentiel>?> search(String query) async => null;
}
