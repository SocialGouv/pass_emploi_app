import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/features/saved_search/delete/saved_search_delete_actions.dart';
import 'package:pass_emploi_app/features/saved_search/delete/saved_search_delete_state.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_state.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_delete_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

void main() {
  group("When repository succeeds…", () {
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.savedSearchDeleteRepository = SavedSearchDeleteRepositorySuccessStub();

    test("saved search should be deleted", () async {
      // Given
      final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());
      final displayedLoading = store.onChange.any((e) => e.savedSearchDeleteState is SavedSearchDeleteLoadingState);
      final successState = store.onChange.firstWhere((e) => e.savedSearchDeleteState is SavedSearchDeleteSuccessState);

      // When
      store.dispatch(SavedSearchDeleteRequestAction("savedSearchId"));

      // Then
      expect(await displayedLoading, isTrue);
      final appState = await successState;
      expect(appState.savedSearchDeleteState is SavedSearchDeleteSuccessState, isTrue);
    });

    test("saved search should be removed from saved searches", () async {
      // Given
      final store = testStoreFactory.initializeReduxStore(
        initialState: loggedInState().copyWith(savedSearchListState: SavedSearchListSuccessState([_mockSavedSearch()])),
      );
      final displayedLoading = store.onChange.any((e) => e.savedSearchDeleteState is SavedSearchDeleteLoadingState);
      final successState = store.onChange.firstWhere((e) => e.savedSearchDeleteState is SavedSearchDeleteSuccessState);

      // When
      store.dispatch(SavedSearchDeleteRequestAction("savedSearchId"));

      // Then
      expect(await displayedLoading, isTrue);
      final appState = await successState;
      expect((appState.savedSearchListState as SavedSearchListSuccessState).savedSearches, isEmpty);
    });
  });

  group("When repository fails…", () {
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.savedSearchDeleteRepository = SavedSearchDeleteRepositoryFailureStub();

    test("saved search delete state should be failure", () async {
      // Given
      final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());
      final displayedLoading = store.onChange.any((e) => e.savedSearchDeleteState is SavedSearchDeleteLoadingState);
      final failureState = store.onChange.firstWhere((e) => e.savedSearchDeleteState is SavedSearchDeleteFailureState);

      // When
      store.dispatch(SavedSearchDeleteRequestAction("savedSearchId"));

      // Then
      expect(await displayedLoading, isTrue);
      final appState = await failureState;
      expect(appState.savedSearchDeleteState is SavedSearchDeleteFailureState, isTrue);
    });

    test("saved search should not be removed from saved searches", () async {
      // Given
      final store = testStoreFactory.initializeReduxStore(
        initialState: loggedInState().copyWith(savedSearchListState: SavedSearchListSuccessState([_mockSavedSearch()])),
      );
      final displayedLoading = store.onChange.any((e) => e.savedSearchDeleteState is SavedSearchDeleteLoadingState);
      final failureState = store.onChange.firstWhere((e) => e.savedSearchDeleteState is SavedSearchDeleteFailureState);

      // When
      store.dispatch(SavedSearchDeleteRequestAction("savedSearchId"));

      // Then
      expect(await displayedLoading, isTrue);
      final appState = await failureState;
      expect((appState.savedSearchListState as SavedSearchListSuccessState).savedSearches, [_mockSavedSearch()]);
    });
  });
}

SavedSearch _mockSavedSearch() {
  return ImmersionSavedSearch(
    id: "savedSearchId",
    title: "",
    metier: "",
    location: mockLocation(),
    filtres: ImmersionFiltresRecherche.noFiltre(),
    ville: "",
    codeRome: "",
  );
}

class SavedSearchDeleteRepositorySuccessStub extends SavedSearchDeleteRepository {
  SavedSearchDeleteRepositorySuccessStub() : super(DioMock());

  @override
  Future<bool> delete(String userId, String savedSearchId) async {
    if (userId == "id" && savedSearchId == "savedSearchId") return true;
    return false;
  }
}

class SavedSearchDeleteRepositoryFailureStub extends SavedSearchDeleteRepository {
  SavedSearchDeleteRepositoryFailureStub() : super(DioMock());

  @override
  Future<bool> delete(String userId, String savedSearchId) async => false;
}
