import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/repositories/Immersion_repository.dart';

import '../doubles/fixtures.dart';
import '../doubles/stubs.dart';
import '../utils/test_assets.dart';

void main() {
  test('getImmersions when response is valid should return immersions', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/offres-immersion")) return invalidHttpResponse();
      if (request.url.queryParameters["rome"] != "J1301") return invalidHttpResponse();
      if (request.url.queryParameters["lat"] != "48.7") return invalidHttpResponse();
      if (request.url.queryParameters["lon"] != "7.7") return invalidHttpResponse();
      return Response(loadTestAssets("immersions.json"), 200);
    });
    final repository = ImmersionRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final immersions = await repository.getImmersions(userId: "ID", codeRome: "J1301", location: _location());

    // Then
    expect(immersions, isNotNull);
    expect(immersions!.length, isNotNull);
    expect(
      immersions.first,
      Immersion(
        id: "036383f3-85ca-4dbd-b636-ae2657164439",
        metier: "xxxx",
        nomEtablissement: "ACCUEIL DE JOUR POUR PERSONNES AGEES",
        secteurActivite: "xxxx",
        ville: "xxxx",
      ),
    );
  });

  test('getImmersions when response is invalid should return null', () async {
    // Given
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = ImmersionRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final immersions = await repository.getImmersions(userId: "ID", codeRome: "J1301", location: _location());

    // Then
    expect(immersions, isNull);
  });

  test('getImmersions when response throws exception should return null', () async {
    // Given
    final httpClient = MockClient((request) async => throw Exception());
    final repository = ImmersionRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final immersions = await repository.getImmersions(userId: "ID", codeRome: "J1301", location: _location());

    // Then
    expect(immersions, isNull);
  });
}

Location _location() {
  return Location(libelle: "Paris", code: "75", type: LocationType.COMMUNE, latitude: 48.7, longitude: 7.7);
}
