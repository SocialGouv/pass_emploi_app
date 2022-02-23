import 'package:async_redux/async_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/redux/actions/saved_search_delete_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/saved_search_delete_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:pass_emploi_app/redux/store/environment.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_delete_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

main() {
  group("When repository succeeds…", () {
    test("saved search should be deleted", () async {
      // Given
      final store = _store(loggedInState(), SavedSearchDeleteRepositorySuccessStub());
      final storeTester = StoreTester.from(store);

      // When
      store.dispatch(SavedSearchDeleteRequestAction("savedSearchId"));

      // Then
      await storeTester.waitCondition((info) => info.state.savedSearchDeleteState is SavedSearchDeleteLoadingState);
      final info = await storeTester.waitCondition(
        (info) => info.state.savedSearchDeleteState is SavedSearchDeleteSuccessState,
      );
      expect(info.first.state.savedSearchDeleteState is SavedSearchDeleteSuccessState, isTrue);
    });

    test("saved search should be removed from saved searches", () async {
      // Given
      final store = _store(
        loggedInState().copyWith(savedSearchesState: State.success([_mockSavedSearch()])),
        SavedSearchDeleteRepositorySuccessStub(),
      );
      final storeTester = StoreTester.from(store);

      // When
      store.dispatch(SavedSearchDeleteRequestAction("savedSearchId"));

      // Then
      await storeTester.waitCondition((info) => info.state.savedSearchDeleteState is SavedSearchDeleteLoadingState);
      final info = await storeTester.waitCondition(
        (info) => info.state.savedSearchDeleteState is SavedSearchDeleteSuccessState,
      );
      expect(info.first.state.savedSearchesState.getResultOrThrow(), isEmpty);
    });
  });

  group("When repository fails…", () {
    test("saved search delete state should be failure", () async {
      // Given
      final store = _store(
        loggedInState(),
        SavedSearchDeleteRepositoryFailureStub(),
      );
      final storeTester = StoreTester.from(store);

      // When
      store.dispatch(SavedSearchDeleteRequestAction("savedSearchId"));

      // Then
      await storeTester.waitCondition((info) => info.state.savedSearchDeleteState is SavedSearchDeleteLoadingState);
      await storeTester.waitCondition((info) => info.state.savedSearchDeleteState is SavedSearchDeleteFailureState);
    });

    test("saved search should not be removed from saved searches", () async {
      // Given
      final store = _store(
        loggedInState().copyWith(savedSearchesState: State.success([_mockSavedSearch()])),
        SavedSearchDeleteRepositoryFailureStub(),
      );
      final storeTester = StoreTester.from(store);

      // When
      store.dispatch(SavedSearchDeleteRequestAction("savedSearchId"));

      // Then
      await storeTester.waitCondition((info) => info.state.savedSearchDeleteState is SavedSearchDeleteLoadingState);
      final info = await storeTester.waitCondition(
        (info) => info.state.savedSearchDeleteState is SavedSearchDeleteFailureState,
      );
      expect(info.first.state.savedSearchesState.getResultOrThrow(), [_mockSavedSearch()]);
    });
  });
}

Store<AppState> _store(AppState state, SavedSearchDeleteRepository repository) {
  return Store<AppState>(
    initialState: state,
    environment: Environment(
      storeV1: TestStoreFactory().initializeReduxStore(initialState: state),
      savedSearchDeleteRepository: repository,
    ),
  );
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
