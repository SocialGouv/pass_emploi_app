import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/saved_search/delete/slice/actions.dart';
import 'package:pass_emploi_app/features/saved_search/delete/slice/state.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_delete_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

main() {
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
        initialState: loggedInState().copyWith(savedSearchesState: State.success([_mockSavedSearch()])),
      );
      final displayedLoading = store.onChange.any((e) => e.savedSearchDeleteState is SavedSearchDeleteLoadingState);
      final successState = store.onChange.firstWhere((e) => e.savedSearchDeleteState is SavedSearchDeleteSuccessState);

      // When
      store.dispatch(SavedSearchDeleteRequestAction("savedSearchId"));

      // Then
      expect(await displayedLoading, isTrue);
      final appState = await successState;
      expect(appState.savedSearchesState.getResultOrThrow(), isEmpty);
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
        initialState: loggedInState().copyWith(savedSearchesState: State.success([_mockSavedSearch()])),
      );
      final displayedLoading = store.onChange.any((e) => e.savedSearchDeleteState is SavedSearchDeleteLoadingState);
      final failureState = store.onChange.firstWhere((e) => e.savedSearchDeleteState is SavedSearchDeleteFailureState);

      // When
      store.dispatch(SavedSearchDeleteRequestAction("savedSearchId"));

      // Then
      expect(await displayedLoading, isTrue);
      final appState = await failureState;
      expect(appState.savedSearchesState.getResultOrThrow(), [_mockSavedSearch()]);
    });
  });
}

SavedSearch _mockSavedSearch() {
  return ImmersionSavedSearch(id: "savedSearchId", title: '', metier: '', location: '', filters: null);
}

class SavedSearchDeleteRepositorySuccessStub extends SavedSearchDeleteRepository {
  SavedSearchDeleteRepositorySuccessStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<bool> delete(String userId, String savedSearchId) async {
    if (userId == "id" && savedSearchId == "savedSearchId") return true;
    return false;
  }
}

class SavedSearchDeleteRepositoryFailureStub extends SavedSearchDeleteRepository {
  SavedSearchDeleteRepositoryFailureStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<bool> delete(String userId, String savedSearchId) async => false;
}
