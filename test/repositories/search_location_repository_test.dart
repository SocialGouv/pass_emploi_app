import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/repositories/search_location_repository.dart';

import '../doubles/fixtures.dart';
import '../dsl/sut_repository2.dart';

void main() {
  group('SearchLocationRepository', () {
    final sut = RepositorySut2<SearchLocationRepository>();
    sut.givenRepository((client) => SearchLocationRepository(client));

    group('getLocations', () {
      sut.when(
        (repository) => repository.getLocations(userId: "userId", query: "paris", villesOnly: true),
      );

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "search_location.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/referentiels/communes-et-departements?recherche=paris&villesOnly=true",
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<List<Location>>((result) {
            expect(result, mockLocations());
          });
        });
      });

      group('when response is invalid', () {
        sut.givenResponseCode(500);

        test('response should be null', () async {
          await sut.expectEmptyListAsResult();
        });
      });
    });
  });
}
