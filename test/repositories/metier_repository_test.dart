import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/repositories/metier_repository.dart';

import '../doubles/fixtures.dart';
import '../dsl/sut_repository.dart';

void main() {
  final sut = RepositorySut<MetierRepository>();
  sut.givenRepository((client) => MetierRepository("BASE_URL", client));

  group('getSuggestions', () {
    group('with input greater than 2 characters', () {
      sut.when((repository) => repository.getMetiers("chevalier"));

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "autocomplete_metiers.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: "GET",
            url: "BASE_URL/referentiels/metiers?recherche=chevalier",
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<List<Metier>?>((result) {
            expect(result, isNotNull);
            expect(result, mockAutocompleteMetiers());
          });
        });
      });

      group('when response is invalid', () {
        sut.givenResponseCode(500);

        test('response should be an empty list', () async {
          await sut.expectEmptyListAsResult();
        });
      });
    });

    group('with input greater lower or equal than 2 characters', () {
      sut.givenJsonResponse(fromJson: "autocomplete_metiers.json");
      sut.when((repository) => repository.getMetiers("ch"));

      test('response should be an empty list', () async {
        await sut.expectEmptyListAsResult();
      });
    });
  });
}
