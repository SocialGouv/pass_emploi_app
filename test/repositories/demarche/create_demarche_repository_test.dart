import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/repositories/demarche/create_demarche_repository.dart';

import '../../doubles/fixtures.dart';
import '../../utils/pass_emploi_mock_client.dart';

void main() {
  test('createDemarche should return true when success', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async {
      if (request.method != "POST") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/jeunes/id/demarches")) return invalidHttpResponse();
      final requestJson = jsonUtf8Decode(request.bodyBytes);
      if (requestJson["description"] != "Description accentuée") return invalidHttpResponse();
      if (requestJson["dateFin"] != "2021-12-23T12:08:10.000") return invalidHttpResponse();
      return Response("", 200);
    });
    final repository = CreateDemarcheRepository("BASE_URL", httpClient);

    // When
    final result = await repository.createDemarche("Description accentuée", DateTime(2021, 12, 23, 12, 8, 10), "id");

    // Then
    expect(result, true);
  });

  test('createDemarche should return true when success', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async => Response("", 400));
    final repository = CreateDemarcheRepository("BASE_URL", httpClient);

    // When
    final result = await repository.createDemarche("description", DateTime(2021, 12, 23, 12, 8, 10), "id");

    // Then
    expect(result, false);
  });
}
