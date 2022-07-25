import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/models/share_preferences.dart';
import 'package:pass_emploi_app/repositories/share_preferences/share_favoris_repository.dart';

import '../doubles/fixtures.dart';
import '../utils/pass_emploi_mock_client.dart';
import '../utils/test_assets.dart';

void main() {
  test('getSharePreferences returns is favorite shared preference', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/jeunes/UID/preferences")) return invalidHttpResponse();
      return Response.bytes(loadTestAssetsAsBytes("share_preferences.json"), 200);
    });
    final repository = SharePreferencesRepository("BASE_URL", httpClient);

    // When
    final SharePreferences? result = await repository.getSharePreferences("UID");

    // Then
    expect(result, isNotNull);
    expect(result, SharePreferences(shareFavoris: true));
    expect(result?.shareFavoris, isNotNull);
    expect(result?.shareFavoris, true);
  });

  test('getSharePreferences returns null when response is not valid', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async => invalidHttpResponse());
    final repository = SharePreferencesRepository("BASE_URL", httpClient);

    // When
    final search = await repository.getSharePreferences("UID");

    // Then
    expect(search, isNull);
  });

  test('putSharePreferences returns is favorite shared preference', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/jeunes/UID/preferences")) return invalidHttpResponse();
      return Response.bytes(loadTestAssetsAsBytes("share_preferences.json"), 200);
    });
    final repository = SharePreferencesRepository("BASE_URL", httpClient);

    // When
    final SharePreferences? result = await repository.getSharePreferences("UID");

    // Then
    expect(result, isNotNull);
    expect(result, SharePreferences(shareFavoris: true));
    expect(result?.shareFavoris, isNotNull);
    expect(result?.shareFavoris, true);
  });

  test('putSharePreferences returns null when response is not valid', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async => invalidHttpResponse());
    final repository = SharePreferencesRepository("BASE_URL", httpClient);

    // When
    final search = await repository.getSharePreferences("UID");

    // Then
    expect(search, isNull);
  });
}
