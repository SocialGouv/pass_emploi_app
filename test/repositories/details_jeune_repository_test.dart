import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/models/details_jeune.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';

import '../doubles/fixtures.dart';
import '../utils/mock_demo_client.dart';
import '../utils/test_assets.dart';
import '../utils/test_datetime.dart';

void main() {
  test('should return details jeune on valid request', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/jeunes/id-jeune")) return invalidHttpResponse();
      return Response(loadTestAssets("details_jeune.json"), 200);
    });
    final repository = DetailsJeuneRepository("BASE_URL", httpClient);

    // When
    final response = await repository.fetch("id-jeune");

    // Then
    expect(
      response,
      DetailsJeune(
        conseiller: DetailsJeuneConseiller(
          firstname: "Nils",
          lastname: "Tavernier",
          sinceDate: parseDateTimeUtcWithCurrentTimeZone('2022-02-15T0:0:0.0Z'),
        ),
      ),
    );
  });

  test('should return null on failed request', () async {
    // Given
    final httpClient = MockClient((request) async => throw Exception());
    final repository = DetailsJeuneRepository("BASE_URL", httpClient);

    // When
    final response = await repository.fetch("id-jeune");

    // Then
    expect(response, isNull);
  });

  test('should return details jeune on valid request', () async {
    // Given
    final httpClient = MockModeDemoClient();
    final repository = DetailsJeuneRepository("BASE_URL", httpClient);

    // When
    final response = await repository.fetch("id-jeune");

    // Then
    expect(response, isNotNull);
  });
}
