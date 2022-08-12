import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/models/commentaire.dart';
import 'package:pass_emploi_app/repositories/action_commentaire_repository.dart';

import '../doubles/fixtures.dart';
import '../utils/pass_emploi_mock_client.dart';
import '../utils/test_assets.dart';
import '../utils/test_datetime.dart';

void main() {
  group('getCommentaires', () {
    test('when response is valid', () async {
      // Given
      final httpClient = PassEmploiMockClient((request) async {
        if (request.method != "GET") return invalidHttpResponse();
        if (!request.url.toString().startsWith("BASE_URL/actions/actionId/commentaires")) return invalidHttpResponse();
        return Response.bytes(loadTestAssetsAsBytes("commentaires.json"), 200);
      });
      final repository = ActionCommentaireRepository("BASE_URL", httpClient);

      // When
      final result = await repository.getCommentaires("actionId");

      // Then
      expect(result, isNotNull);
      expect(result?.length, 2);
      expect(
        result?[0],
        Commentaire(
          id: "8392839",
          content: "Premier commentaire",
          creationDate: parseDateTimeUtcWithCurrentTimeZone("2022-07-23T12:08:10.000"),
          createdByAdvisor: true,
          creatorName: "Nils Tavernier",
        ),
      );
      expect(
        result?[1],
        Commentaire(
          id: "8802034",
          content: "Deuxieme commentaire",
          creationDate: parseDateTimeUtcWithCurrentTimeZone("2022-07-23T17:08:10.000"),
          createdByAdvisor: false,
          creatorName: null,
        ),
      );
    });

    test('when response is invalid should return null', () async {
      // Given
      final httpClient = PassEmploiMockClient((request) async => invalidHttpResponse());
      final repository = ActionCommentaireRepository("BASE_URL", httpClient);

      // When
      final search = await repository.getCommentaires("actionId");

      // Then
      expect(search, isNull);
    });
  });
}
