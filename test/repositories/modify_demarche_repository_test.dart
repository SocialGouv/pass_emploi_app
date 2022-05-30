import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/models/user_action_pe.dart';
import 'package:pass_emploi_app/repositories/modify_demarche_repository.dart';

import '../doubles/fixtures.dart';

void main() {
  test('modifyDemarche when response is valid should return true', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "PUT") return invalidHttpResponse(message: "Ce n'est pas la bonne methode, il faut un PUT");
      if (!request.url.toString().startsWith("BASE_URL/jeunes/ronaldo/demarches/remporterLaC1/statut")) return invalidHttpResponse(message: "Ce n'est pas le bon url");
      expect(request.bodyFields, {"statut": "A_FAIRE", "dateDebut": "2021-12-23T12:08:10.000"});
      return Response("", 200);
    });
    final repository = ModifyDemarcheRepository("BASE_URL", httpClient);

    // When
    final result = await repository.modifyDemarche("ronaldo", "remporterLaC1", UserActionPEStatus.NOT_STARTED, DateTime(2021, 12, 23, 12, 8, 10));

    // Then
    expect(result, true);
  });

  test('modifyDemarche when response is not valid should return false', () async {
    // Given
    final httpClient = MockClient((request) async {
      return Response("", 400);
    });
    final repository = ModifyDemarcheRepository("BASE_URL", httpClient);

    // When
    final result = await repository.modifyDemarche("ronaldo", "remporterLaC1", UserActionPEStatus.NOT_STARTED, DateTime(2021, 12, 23, 12, 8, 10));

    // Then
    expect(result, false);
  });
}
