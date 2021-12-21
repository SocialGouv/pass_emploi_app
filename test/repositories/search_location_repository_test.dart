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
      if (request.url.toString() != "BASE_URL/referentiels/communes-et-departements?recherche=pari&villesOnly=false") {
        return invalidHttpResponse();
      }
      return Response.bytes(loadTestAssetsAsBytes("search_location.json"), 200);
    });
    final repository = SearchLocationRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final List<Location> locations = await repository.getLocations(userId: "ID", query: "pari");

    // Then
    expect(locations.length, 5);
    expect(locations.first, Location(libelle: "Paris", code: "75", codePostal: null, type: LocationType.DEPARTMENT));
    expect(locations[1], Location(libelle: "PARIGNY", code: "42166", codePostal: "42120", type: LocationType.COMMUNE));
  });

  test('getLocations when response is invalid should return empty list', () async {
    // Given
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = SearchLocationRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final List<Location> locations = await repository.getLocations(userId: "ID", query: "pari");

    // Then
    expect(locations, isEmpty);
  });

  test('getLocations when response throws exception should return empty list', () async {
    // Given
    final httpClient = MockClient((request) async => throw Exception());
    final repository = SearchLocationRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final List<Location> locations = await repository.getLocations(userId: "ID", query: "pari");

    // Then
    expect(locations, isEmpty);
  });

  test('getLocations when villesOnlyParameter is true should set it in query parameters', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "GET") throw Exception();
      if (request.url.toString() != "BASE_URL/referentiels/communes-et-departements?recherche=pari&villesOnly=true") {
        throw Exception();
      }
      return Response.bytes(loadTestAssetsAsBytes("search_location.json"), 200);
    });
    final repository = SearchLocationRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final result = await repository.getLocations(userId: "ID", query: "pari", villesOnly: true);

    // Then
    expect(result, isNotEmpty);
  });
}
