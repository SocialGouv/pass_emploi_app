import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/accepter/accepter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/accepter/accepter_suggestion_recherche_state.dart';
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

class SuggestionsRechercheRepositorySuccessStub extends SuggestionsRechercheRepository {
  SuggestionsRechercheRepositorySuccessStub() : super("", DummyHttpClient());

  @override
  Future<bool> accepterSuggestion({required String userId, required String suggestionId}) async {
    return true;
  }
}

class SuggestionsRechercheRepositoryErrorStub extends SuggestionsRechercheRepository {
  SuggestionsRechercheRepositoryErrorStub() : super("", DummyHttpClient());

  @override
  Future<bool> accepterSuggestion({required String userId, required String suggestionId}) async {
    return false;
  }
}
