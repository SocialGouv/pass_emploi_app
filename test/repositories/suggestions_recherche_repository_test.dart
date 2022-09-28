import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';
import 'package:pass_emploi_app/repositories/suggestions_recherche_repository.dart';

import '../doubles/fixtures.dart';
import '../dsl/sut_repository.dart';

void main() {
  final sut = RepositorySut<SuggestionsRechercheRepository>();
  sut.givenRepository((client) => SuggestionsRechercheRepository("BASE_URL", client));

  group('getSuggestions', () {
    sut.when((repository) => repository.getSuggestions("UID"));

    group('when response is valid', () {
      sut.givenJsonResponse(fromJson: "suggestions_recherche.json");

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: "GET",
          url: "BASE_URL/jeunes/UID/recherches/suggestions",
        );
      });

      test('response should be valid', () async {
        await sut.expectResult<List<SuggestionRecherche>?>((result) {
          expect(result, isNotNull);
          expect(result, mockSuggestionsRecherche());
        });
      });
    });

    group('when response is invalid', () {
      sut.givenResponseCode(500);

      test('response should be null', () async {
        await sut.expectNullResult();
      });
    });
  });

  group('accepterSuggestion', () {
    sut.when((repository) => repository.accepterSuggestion(userId: "USERID", suggestionId: "SUGGID"));

    group('when response is valid', () {
      sut.givenResponseCode(200);

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: "POST",
          url: "BASE_URL/jeunes/USERID/recherches/suggestions/SUGGID/creer-recherche",
        );
      });

      test('response should be valid', () async {
        await sut.expectTrueAsResult();
      });
    });

    group('when response is invalid', () {
      sut.givenResponseCode(500);

      test('response should be null', () async {
        await sut.expectFalseAsResult();
      });
    });
  });
}
