import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/repositories/demarche/create_demarche_repository.dart';

import '../../doubles/fixtures.dart';
import '../../utils/pass_emploi_mock_client.dart';

void main() {
  test('createDemarche should return true when success', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async {
      if (request.method != "POST") return invalidHttpResponse(message: "Ce n'est pas la bonne methode, il faut un POST");
      if (!request.url.toString().startsWith("BASE_URL/jeunes/ronaldo/demarches")) {
        return invalidHttpResponse(message: "Ce n'est pas le bon url");
      }
      expect(request.bodyFields, {"description": "Bonjour je suis une description", "dateFin": "2021-12-23T12:08:10.000"});
      return Response("", 200);
    });
    final repository = CreateDemarcheRepository("BASE_URL", httpClient);

    // When
    final result = await repository.createDemarche(
      "Bonjour je suis une description",
      DateTime(2021, 12, 23, 12, 8, 10),
      "ronaldo",
    );

    // Then
    expect(result, true);
  });

  test('createDemarche should return true when success', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async {
      return Response("", 400);
    });
    final repository = CreateDemarcheRepository("BASE_URL", httpClient);

    // When
    final result = await repository.createDemarche(
      "Bonjour je suis une description",
      DateTime(2021, 12, 23, 12, 8, 10),
      "ronaldo",
    );

    // Then
    expect(result, false);
  });
}
