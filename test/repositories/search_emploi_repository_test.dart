import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/repositories/search_location_repository.dart';

import '../doubles/fixtures.dart';
import '../doubles/stubs.dart';
import '../utils/test_assets.dart';

void main() {
  test('getLocations when response is valid should return locations', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/referentiels/communes-et-departements?recherche=pa")) {
        return invalidHttpResponse();
      }
      return Response.bytes(loadTestAssetsAsBytes("search_location.json"), 200);
    });
    final repository = SearchLocationRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final List<Location> locations = await repository.getLocations(userId: "ID", query: "pa");

    // Then
    expect(locations.length, 5);
    expect(
      locations.first,
      Location(libelle: "PAU", code: "64445", codePostal: "64000", type: LocationType.COMMUNE),
    );
  });

  test('getLocations when response is invalid should return empty list', () async {
    // Given
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = SearchLocationRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final List<Location> locations = await repository.getLocations(userId: "ID", query: "pa");

    // Then
    expect(locations, isEmpty);
  });

  test('getLocations when response throws exception should return empty list', () async {
    // Given
    final httpClient = MockClient((request) async => throw Exception());
    final repository = SearchLocationRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final List<Location> locations = await repository.getLocations(userId: "ID", query: "pa");

    // Then
    expect(locations, isEmpty);
  });
}
