import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_state.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_state.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_state.dart';
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

  group("when requesting to accepter une suggestion", () {
    sut.when(() => TraiterSuggestionRechercheRequestAction(suggestionCariste(), TraiterSuggestionType.accepter));

    test('should load then succeed when request succeed', () {
      sut.givenStore = givenState()
          .loggedInUser() //
          .store((f) => {f.suggestionsRechercheRepository = SuggestionsRechercheRepositoryStub(accepterSucceed: true)});

      sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceedAccepter()]);
    });

    test('should remove suggestion when request succeed', () {
      sut.givenStore = givenState()
          .loggedInUser() //
          .withSuggestionsRecherche()
          .store((f) => {f.suggestionsRechercheRepository = SuggestionsRechercheRepositoryStub(accepterSucceed: true)});

      sut.thenExpectChangingStatesThroughOrder([_suggestionShouldBeRemoved()]);
    });

    test('should refresh saved search list when request succeed', () {
      sut.givenStore = givenState()
          .loggedInUser() //
          .withSuggestionsRecherche()
          .store((f) => {
                f.suggestionsRechercheRepository = SuggestionsRechercheRepositoryStub(accepterSucceed: true),
                f.getSavedSearchRepository = SavedSearchRepositorySuccessStub(),
              });

      sut.thenExpectChangingStatesThroughOrder([_shouldReloadSavedSearchList()]);
    });

    test('should load then fail when request fail', () {
      sut.givenStore = givenState()
          .loggedInUser() //
          .store(
              (f) => {f.suggestionsRechercheRepository = SuggestionsRechercheRepositoryStub(accepterSucceed: false)});

      sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
    });
  });

  group("when requesting to refuser une suggestion", () {
    sut.when(() => TraiterSuggestionRechercheRequestAction(suggestionCariste(), TraiterSuggestionType.refuser));

    test('should load then succeed when request succeed', () {
      sut.givenStore = givenState()
          .loggedInUser() //
          .store((f) => {f.suggestionsRechercheRepository = SuggestionsRechercheRepositoryStub(refuserSucceed: true)});

      sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceedRefuser()]);
    });

    test('should remove suggestion when request succeed', () {
      sut.givenStore = givenState()
          .loggedInUser() //
          .withSuggestionsRecherche()
          .store((f) => {f.suggestionsRechercheRepository = SuggestionsRechercheRepositoryStub(refuserSucceed: true)});

      sut.thenExpectChangingStatesThroughOrder([_suggestionShouldBeRemoved()]);
    });

    test('should load then fail when request fail', () {
      sut.givenStore = givenState()
          .loggedInUser() //
          .store((f) => {f.suggestionsRechercheRepository = SuggestionsRechercheRepositoryStub(refuserSucceed: false)});

      sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
    });
  });

  group("when reseting traiter une suggestion", () {
    sut.when(() => TraiterSuggestionRechercheResetAction());

    test("should reset state", () {
      sut.givenStore = givenState().succeedAccepterSuggestionRecherche().store();

      sut.thenExpectChangingStatesThroughOrder([_shouldResetTraiterState()]);
    });
  });
}

Matcher _shouldLoad() =>
    StateIs<TraiterSuggestionRechercheLoadingState>((state) => state.traiterSuggestionRechercheState);

Matcher _shouldFail() =>
    StateIs<TraiterSuggestionRechercheFailureState>((state) => state.traiterSuggestionRechercheState);

Matcher _shouldSucceedAccepter() {
  return StateIs<AccepterSuggestionRechercheSuccessState>(
    (state) => state.traiterSuggestionRechercheState,
    (state) {
      expect(state.savedSearch, offreEmploiSavedSearch());
    },
  );
}

Matcher _shouldSucceedRefuser() {
  return StateIs<RefuserSuggestionRechercheSuccessState>((state) => state.traiterSuggestionRechercheState);
}

Matcher _suggestionShouldBeRemoved() {
  return StateMatch((state) {
    final suggestionState = state.suggestionsRechercheState;
    return suggestionState is SuggestionsRechercheSuccessState &&
        suggestionState.suggestions.firstWhereOrNull((e) => e.id == suggestionCariste().id) == null;
  });
}

Matcher _shouldReloadSavedSearchList() => StateIs<SavedSearchListSuccessState>((state) => state.savedSearchListState);

Matcher _shouldResetTraiterState() =>
    StateIs<TraiterSuggestionRechercheNotInitializedState>((state) => state.traiterSuggestionRechercheState);

class SuggestionsRechercheRepositoryStub extends SuggestionsRechercheRepository {
  final bool accepterSucceed;
  final bool refuserSucceed;

  SuggestionsRechercheRepositoryStub({this.accepterSucceed = true, this.refuserSucceed = true})
      : super("", DummyHttpClient(), DummyPassEmploiCacheManager());

  @override
  Future<SavedSearch?> accepterSuggestion({required String userId, required String suggestionId}) async {
    return accepterSucceed ? offreEmploiSavedSearch() : null;
  }

  @override
  Future<bool> refuserSuggestion({required String userId, required String suggestionId}) async {
    return refuserSucceed;
  }
}

class SavedSearchRepositorySuccessStub extends GetSavedSearchRepository {
  SavedSearchRepositorySuccessStub() : super("", DummyHttpClient(), DummyCrashlytics());

  @override
  Future<List<SavedSearch>?> getSavedSearch(String userId) async {
    return [];
  }
}
