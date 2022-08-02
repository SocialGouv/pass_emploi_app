import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/models/partage_activite.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/repositories/partage_activite_repository.dart';

import '../doubles/dummies.dart';
import '../doubles/fixtures.dart';
import '../utils/pass_emploi_mock_client.dart';
import '../utils/test_assets.dart';

void main() {
  test('getPartageActivite returns is favorite shared preference', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/jeunes/UID/preferences")) return invalidHttpResponse();
      return Response.bytes(loadTestAssetsAsBytes("partage_activite.json"), 200);
    });
    final repository = PartageActiviteRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final PartageActivite? result = await repository.getPartageActivite("UID");

    // Then
    expect(result, isNotNull);
    expect(result, PartageActivite(partageFavoris: true));
    expect(result?.partageFavoris, isNotNull);
    expect(result?.partageFavoris, true);
  });

  test('getPartageActivite returns null when response is not valid', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async => invalidHttpResponse());
    final repository = PartageActiviteRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final result = await repository.getPartageActivite("UID");

    // Then
    expect(result, isNull);
  });

  test('putPartageActivite returns is favorite shared preference', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async {
      if (request.method != "PUT") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/jeunes/UID/preferences")) return invalidHttpResponse();
      final requestJson = jsonUtf8Decode(request.bodyBytes);
      if (requestJson['partageFavoris'] != true) return invalidHttpResponse();
      return Response('', 200);
    });
    final repository = PartageActiviteRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final result = await repository.updatePartageActivite("UID", true);

    // Then
    expect(result, isTrue);
  });

  test('putPartageActivite returns null when response is not valid', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async => invalidHttpResponse());
    final repository = PartageActiviteRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final result = await repository.updatePartageActivite("UID", true);

    // Then
    expect(result, isFalse);
  });
}
