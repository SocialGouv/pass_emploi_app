import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_details_repository.dart';

import '../doubles/fixtures.dart';
import '../utils/test_assets.dart';

void main() {
  test(
      'getOffreEmploiDetails when response is valid with all parameters should return offres and flag response as error-free',
      () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/offres-emploi/ID")) return invalidHttpResponse();
      return Response.bytes(loadTestAssetsAsBytes("offre_emploi_details.json"), 200);
    });
    final repository = OffreEmploiDetailsRepository("BASE_URL", httpClient);

    // When
    final offre = await repository.getOffreEmploiDetails(offreId: "ID");

    // Then
    expect(offre.details, isNotNull);
    expect(offre.details, mockOffreEmploiDetails());
    expect(offre.isGenericFailure, isFalse);
    expect(offre.isOffreNotFound, isFalse);
  });

  test('getOffreEmploiDetails when response is invalid should flag response as not found', () async {
    // Given
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = OffreEmploiDetailsRepository("BASE_URL", httpClient);

    // When
    final offre = await repository.getOffreEmploiDetails(offreId: "ID");

    // Then
    expect(offre.details, isNull);
    expect(offre.isGenericFailure, isFalse);
    expect(offre.isOffreNotFound, isTrue);
  });

  test('getOffreEmploiDetails when response throws exception should flag response as generic failure', () async {
    // Given
    final httpClient = MockClient((request) async => throw Exception());
    final repository = OffreEmploiDetailsRepository("BASE_URL", httpClient);

    // When
    final offre = await repository.getOffreEmploiDetails(offreId: "ID");

    // Then
    expect(offre.details, isNull);
    expect(offre.isGenericFailure, isTrue);
    expect(offre.isOffreNotFound, isFalse);
  });

  test('getOffreEmploiDetails when response throws exception with 404 code should flag response as not found',
      () async {
    // Given
    final httpClient = MockClient((request) async => throw deletedOfferHttpResponse());
    final repository = OffreEmploiDetailsRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final offre = await repository.getOffreEmploiDetails(offreId: "ID");

    // Then
    expect(offre.details, isNull);
    expect(offre.isGenericFailure, isFalse);
    expect(offre.isOffreNotFound, isTrue);
  });
}
