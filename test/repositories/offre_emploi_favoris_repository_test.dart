import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_favoris_repository.dart';

import '../doubles/fixtures.dart';
import '../doubles/stubs.dart';
import '../utils/test_assets.dart';

main() {
  test('getOffreEmploiFavorisId when response is valid with all parameters should return offres', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId/favoris")) return invalidHttpResponse();
      return Response.bytes(loadTestAssetsAsBytes("offre_emploi_favoris_id.json"), 200);
    });
    final repository = OffreEmploiFavorisRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final favoris = await repository.getOffreEmploiFavorisId("jeuneId");

    // Then
    expect(favoris, ["124GQRG", "124FGRM", "124FGFB", "124FGJJ"]);
  });

  test('getOffreEmploiFavorisId when response is invalid should return null', () async {
    // Given
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = OffreEmploiFavorisRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final favoris = await repository.getOffreEmploiFavorisId("jeuneId");

    // Then
    expect(favoris, isNull);
  });
}
