import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/repositories/suggestions_recherche_repository.dart';

import '../doubles/fixtures.dart';
import '../doubles/spies.dart';
import '../dsl/sut_repository.dart';

void main() {
  var cacheManager = SpyPassEmploiCacheManager();
  setUp(() => cacheManager = SpyPassEmploiCacheManager());

  final sut = RepositorySut<SuggestionsRechercheRepository>();
  sut.givenRepository((client) => SuggestionsRechercheRepository("BASE_URL", client, cacheManager));

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
          expect(result, [suggestionCariste(), suggestionBoulanger(), suggestionPlombier()]);
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
      sut.givenJsonResponse(fromJson: "suggestions_recherche_emploi_acceptee.json");

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: "POST",
          url: "BASE_URL/jeunes/USERID/recherches/suggestions/SUGGID/accepter",
        );
      });

      test('response should be valid', () async {
        await sut.expectResult<OffreEmploiSavedSearch?>((response) {
          expect(response, isNotNull);
          expect(response, offreEmploiSavedSearch());
        });
      });

      test('cache for saved search and suggestions should be reset', () async {
        await sut.expectResult<dynamic>((result) {
          expect(cacheManager.removeResourceParams, CachedResource.SAVED_SEARCH);
          expect(cacheManager.removeSuggestionsRechercheResourceWasCalled, true);
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

  group('refuserSuggestion', () {
    sut.when((repository) => repository.refuserSuggestion(userId: "USERID", suggestionId: "SUGGID"));

    group('when response is valid', () {
      sut.givenResponseCode(200);

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: "POST",
          url: "BASE_URL/jeunes/USERID/recherches/suggestions/SUGGID/refuser",
        );
      });

      test('response should be valid', () async {
        await sut.expectTrueAsResult();
      });

      test('cache for saved search and suggestions should be reset', () async {
        await sut.expectResult<dynamic>((result) {
          expect(cacheManager.removeResourceParams, CachedResource.SAVED_SEARCH);
          expect(cacheManager.removeSuggestionsRechercheResourceWasCalled, true);
        });
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
