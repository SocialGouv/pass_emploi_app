import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_details_repository.dart';

import '../doubles/fixtures.dart';
import '../doubles/stubs.dart';
import '../utils/test_assets.dart';

void main() {
  test('getOffreEmploiDetails when response is valid with all parameters should return offres', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/offres-emploi/ID")) return invalidHttpResponse();
      return Response.bytes(loadTestAssetsAsBytes("offre_emploi_details.json"), 200);
    });
    final repository = OffreEmploiDetailsRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final offre = await repository.getOffreEmploiDetails(offreId: "ID");

    // Then
    expect(offre!, isNotNull);
    expect(offre, mockOffreEmploiDetails());
  });

  test('getOffreEmploiDetails when response is invalid should return null', () async {
    // Given
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = OffreEmploiDetailsRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final offre = await repository.getOffreEmploiDetails(offreId: "ID");

    // Then
    expect(offre, isNull);
  });
}
