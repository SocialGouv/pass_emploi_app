import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/repositories/demarche/update_demarche_repository.dart';

import '../../doubles/fixtures.dart';
import '../../utils/pass_emploi_mock_client.dart';
import '../../utils/test_assets.dart';

void main() {
  test('updateDemarche when response is valid should return true', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async {
      if (request.method != 'PUT') return invalidHttpResponse();
      if (!request.url.toString().startsWith('BASE_URL/jeunes/user-id/demarches/8802034/statut')) {
        return invalidHttpResponse();
      }
      expect(
        request.bodyFields,
        {
          "statut": "A_FAIRE",
          "dateFin": "2021-12-24T12:08:10.000",
          "dateDebut": "2021-12-23T12:08:10.000",
        },
      );
      return Response.bytes(loadTestAssetsAsBytes('demarche_modified.json'), 200);
    });
    final repository = UpdateDemarcheRepository('BASE_URL', httpClient);

    // When
    final result = await repository.updateDemarche(
      'user-id',
      '8802034',
      DemarcheStatus.NOT_STARTED,
      DateTime(2021, 12, 24, 12, 8, 10),
      DateTime(2021, 12, 23, 12, 8, 10),
    );

    // Then
    expect(result, isNotNull);
    expect(result!.id, '8802034');
  });

  test('updateDemarche when response is not valid should return false', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async {
      return Response('', 400);
    });
    final repository = UpdateDemarcheRepository('BASE_URL', httpClient);

    // When
    final result = await repository.updateDemarche(
      'user-id',
      '8802034',
      DemarcheStatus.NOT_STARTED,
      DateTime(2021, 12, 24, 12, 8, 10),
      DateTime(2021, 12, 23, 12, 8, 10),
    );

    // Then
    expect(result, isNull);
  });
}
