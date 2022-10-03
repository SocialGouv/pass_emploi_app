import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_state.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/accepter/accepter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/accepter/accepter_suggestion_recherche_state.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_state.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searches_repository.dart';
import 'package:pass_emploi_app/repositories/suggestions_recherche_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  final sut = StoreSut();

  group("when requesting to accept suggestion", () {
    sut.when(() => AccepterSuggestionRechercheRequestAction(suggestionCariste()));

    test('should load then succeed when request succeed', () {
      sut.givenStore = givenState()
          .loggedInUser() //
          .store((f) => {f.suggestionsRechercheRepository = SuggestionsRechercheRepositorySuccessStub()});

      sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
    });

    test('should remove suggestion when request succeed', () {
      sut.givenStore = givenState()
          .loggedInUser() //
          .withSuggestionsRecherche()
          .store((f) => {f.suggestionsRechercheRepository = SuggestionsRechercheRepositorySuccessStub()});

      sut.thenExpectChangingStatesThroughOrder([_suggestionShouldBeRemoved()]);
    });

    test('should refresh saved search list when request succeed', () {
      sut.givenStore = givenState()
          .loggedInUser() //
          .withSuggestionsRecherche()
          .store((f) => {
                f.suggestionsRechercheRepository = SuggestionsRechercheRepositorySuccessStub(),
                f.getSavedSearchRepository = SavedSearchRepositorySuccessStub(),
              });

      sut.thenExpectChangingStatesThroughOrder([_shouldReloadSavedSearchList()]);
    });

    test('should load then fail when request fail', () {
      sut.givenStore = givenState()
          .loggedInUser() //
          .store((f) => {f.suggestionsRechercheRepository = SuggestionsRechercheRepositoryErrorStub()});

      sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
    });
  });
}

Matcher _shouldLoad() =>
    StateIs<AccepterSuggestionRechercheLoadingState>((state) => state.accepterSuggestionRechercheState);

Matcher _shouldFail() =>
    StateIs<AccepterSuggestionRechercheFailureState>((state) => state.accepterSuggestionRechercheState);

Matcher _shouldSucceed() {
  return StateIs<AccepterSuggestionRechercheSuccessState>(
    (state) => state.accepterSuggestionRechercheState,
    (state) {
      expect(state.suggestion, suggestionCariste());
    },
  );
}

Matcher _suggestionShouldBeRemoved() {
  return StateMatch((state) {
    final suggestionState = state.suggestionsRechercheState;
    return suggestionState is SuggestionsRechercheSuccessState &&
        suggestionState.suggestions.firstWhereOrNull((e) => e.id == suggestionCariste().id) == null;
  });
}

Matcher _shouldReloadSavedSearchList() => StateIs<SavedSearchListSuccessState>((state) => state.savedSearchListState);

class SuggestionsRechercheRepositorySuccessStub extends SuggestionsRechercheRepository {
  SuggestionsRechercheRepositorySuccessStub() : super("", DummyHttpClient(), DummyPassEmploiCacheManager());

  @override
  Future<bool> accepterSuggestion({required String userId, required String suggestionId}) async {
    return true;
  }
}

class SuggestionsRechercheRepositoryErrorStub extends SuggestionsRechercheRepository {
  SuggestionsRechercheRepositoryErrorStub() : super("", DummyHttpClient(), DummyPassEmploiCacheManager());

  @override
  Future<bool> accepterSuggestion({required String userId, required String suggestionId}) async {
    return false;
  }
}

class SavedSearchRepositorySuccessStub extends GetSavedSearchRepository {
  SavedSearchRepositorySuccessStub() : super("", DummyHttpClient(), DummyCrashlytics());

  @override
  Future<List<SavedSearch>?> getSavedSearch(String userId) async {
    return [];
  }
}
