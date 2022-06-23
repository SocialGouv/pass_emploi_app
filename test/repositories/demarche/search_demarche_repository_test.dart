import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/repositories/demarche/search_demarche_repository.dart';

import '../../doubles/fixtures.dart';
import '../../utils/pass_emploi_mock_client.dart';
import '../../utils/test_assets.dart';

void main() {
  test('search when response is valid should return demarches du referentiel', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/referentiels/pole-emploi/types-demarches?recherche=query")) {
        return invalidHttpResponse();
      }
      return Response.bytes(loadTestAssetsAsBytes("demarches_du_referentiel.json"), 200);
    });
    final repository = SearchDemarcheRepository("BASE_URL", httpClient);

    // When
    final result = await repository.search('query');

    // Then
    expect(result, isNotNull);
    expect(result!.length, 1);
    expect(result.first.id, isNotNull);
    expect(result.first.quoi, 'Mes candidatures');
    expect(result.first.pourquoi, 'Participation');
    expect(result.first.codeQuoi, 'P01');
    expect(result.first.codePourquoi, 'P8');
    expect(
      result.first.comments,
      [Comment(label: 'En voiture', code: 'VOITURE'), Comment(label: 'En avion', code: 'AVION')],
    );
    expect(result.first.isCommentMandatory, isTrue);
  });

  test('search when response is invalid should return null', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async => Response("", 400));
    final repository = SearchDemarcheRepository("BASE_URL", httpClient);

    // When
    final result = await repository.search('query');

    // Then
    expect(result, isNull);
  });

  test('search when repository throws Exception should return null', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async => throw Exception());
    final repository = SearchDemarcheRepository("BASE_URL", httpClient);

    // When
    final result = await repository.search('query');

    // Then
    expect(result, isNull);
  });
}
