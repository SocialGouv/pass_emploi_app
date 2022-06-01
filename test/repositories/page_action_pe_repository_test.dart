import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/page_actions_pe.dart';
import 'package:pass_emploi_app/models/user_action_pe.dart';
import 'package:pass_emploi_app/repositories/page_action_pe_repository.dart';

import '../doubles/fixtures.dart';
import '../utils/mock_demo_client.dart';
import '../utils/pass_emploi_mock_client.dart';
import '../utils/test_assets.dart';
import '../utils/test_datetime.dart';

void main() {
  test('getPageActionsPE', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/jeunes/UID/home/demarches")) {
        return invalidHttpResponse();
      }
      return Response.bytes(loadTestAssetsAsBytes("home_demarches.json"), 200);
    });
    final repository = PageActionPERepository("BASE_URL", httpClient);

    // When
    final PageActionsPE? result = await repository.getPageActionsPE("UID");

    // Then
    expect(result, isNotNull);
    expect(result?.campagne, isNotNull);
    expect(
      result?.campagne,
      Campagne(
        id: "id-campagne",
        titre: "Votre expérience sur l'application",
        description: "Donnez nous votre avis",
        questions: [
          Question(id: 1, libelle: "la question ?", options: [
            Option(id: 1, libelle: "Non, pas du tout"),
          ])
        ],
      ),
    );
    expect(result?.actions, isNotNull);
    expect(result?.actions.length, 7);
    expect(
      result?.actions.first,
      UserActionPE(
        id: "2341739",
        content: "Identification de ses compétences avec pole-emploi.fr",
        status: UserActionPEStatus.IN_PROGRESS,
        endDate: parseDateTimeUtcWithCurrentTimeZone('2021-12-21T09:00:00.000Z'),
        deletionDate: null,
        createdByAdvisor: true,
        label: "Mon (nouveau) métier",
        possibleStatus: [
          UserActionPEStatus.CANCELLED,
          UserActionPEStatus.DONE,
          UserActionPEStatus.NOT_STARTED,
          UserActionPEStatus.IN_PROGRESS
        ],
        creationDate: parseDateTimeUtcWithCurrentTimeZone('2022-05-11T09:04:00.000Z'),
        modifiedByAdvisor: false,
        sousTitre: "Par un autre moyen",
        titre: "Identification de ses points forts et de ses compétences",
        modificationDate: null,
        attributs: [
          PeActionAttribut("Agriculture", "Nom du métier"),
        ],
      ),
    );
  });

  test('getPageActionsPE when response is invalid should return null', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async => invalidHttpResponse());
    final repository = PageActionPERepository("BASE_URL", httpClient);

    // When
    final search = await repository.getPageActionsPE("UserID");

    // Then
    expect(search, isNull);
  });

  test('mode demo should return valid request', () async {
    // Given
    final httpClient = MockModeDemoClient();
    final repository = PageActionPERepository("BASE_URL", httpClient);

    // When
    final response = await repository.getPageActionsPE("UserID");

    // Then
    expect(response, isNotNull);
    expect(response?.campagne, isNotNull);
    expect(response?.actions, isNotNull);
  });
}
