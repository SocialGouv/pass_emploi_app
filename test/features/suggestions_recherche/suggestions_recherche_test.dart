import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_state.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';
import 'package:pass_emploi_app/repositories/suggestions_recherche_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  final sut = StoreSut();

  group("when requesting suggestions", () {
    sut.whenDispatchingAction(() => SuggestionsRechercheRequestAction());

    test('should load then succeed when request succeeds', () {
      sut.givenStore = givenState()
          .loggedIn() //
          .store((f) => {f.suggestionsRechercheRepository = SuggestionsRechercheRepositorySuccessStub()});

      sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
    });

    test('should load then fail when request fails', () {
      sut.givenStore = givenState()
          .loggedInPoleEmploiUser() //
          .store((f) => {f.suggestionsRechercheRepository = SuggestionsRechercheRepositoryErrorStub()});

      sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
    });
  });
}

Matcher _shouldLoad() => StateIs<SuggestionsRechercheLoadingState>((state) => state.suggestionsRechercheState);

Matcher _shouldFail() => StateIs<SuggestionsRechercheFailureState>((state) => state.suggestionsRechercheState);

Matcher _shouldSucceed() {
  return StateIs<SuggestionsRechercheSuccessState>(
    (state) => state.suggestionsRechercheState,
    (state) {
      expect(state.suggestions, mockSuggestionsRecherche());
    },
  );
}

class SuggestionsRechercheRepositorySuccessStub extends SuggestionsRechercheRepository {
  SuggestionsRechercheRepositorySuccessStub() : super(DioMock(), DummyPassEmploiCacheManager());

  @override
  Future<List<SuggestionRecherche>?> getSuggestions(String userId) async {
    return mockSuggestionsRecherche();
  }
}

class SuggestionsRechercheRepositoryErrorStub extends SuggestionsRechercheRepository {
  SuggestionsRechercheRepositoryErrorStub() : super(DioMock(), DummyPassEmploiCacheManager());

  @override
  Future<List<SuggestionRecherche>?> getSuggestions(String userId) async {
    return null;
  }
}
