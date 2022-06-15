import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/repositories/demarche/demarche_de_referentiel_repository.dart';

import '../../doubles/fixtures.dart';
import '../../utils/pass_emploi_mock_client.dart';
import '../../utils/test_assets.dart';

void main() {
  test('getDemarchesDuReferentiel when response is valid should return demarches du referentiel', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/referentiels/pole-emploi/types-demarches?recherche=query")) {
        return invalidHttpResponse();
      }
      return Response.bytes(loadTestAssetsAsBytes("demarches_du_referentiel.json"), 200);
    });
    final repository = DemarcheDuReferentielRepository("BASE_URL", httpClient);

    // When
    final result = await repository.getDemarchesDuReferentiel('query');

    // Then
    expect(result, isNotNull);
    expect(result!.length, 1);
    expect(
      result.first,
      DemarcheDuReferentiel(
        quoi: 'Mes candidatures',
        pourquoi: 'Participation',
        codeQuoi: 'P01',
        codePourquoi: 'P8',
        comments: [
          Comment(label: 'En voiture', code: 'VOITURE'),
          Comment(label: 'En avion', code: 'AVION'),
        ],
        commentObligatoire: true,
      ),
    );
  });

  test('getDemarchesDuReferentiel when response is invalid should return null', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async => Response("", 400));
    final repository = DemarcheDuReferentielRepository("BASE_URL", httpClient);

    // When
    final result = await repository.getDemarchesDuReferentiel('query');

    // Then
    expect(result, isNull);
  });

  test('getDemarchesDuReferentiel when repository throws Exception should return null', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async => throw Exception());
    final repository = DemarcheDuReferentielRepository("BASE_URL", httpClient);

    // When
    final result = await repository.getDemarchesDuReferentiel('query');

    // Then
    expect(result, isNull);
  });
}
