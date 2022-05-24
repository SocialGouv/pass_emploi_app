import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/home_demarches.dart';
import 'package:pass_emploi_app/models/user_action_pe.dart';
import 'package:pass_emploi_app/repositories/user_action_pe_repository.dart';

import '../doubles/fixtures.dart';
import '../utils/test_assets.dart';
import '../utils/test_datetime.dart';

void main() {
  test('get home demarches', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/jeunes/UID/home/demarches")) return invalidHttpResponse();
      return Response.bytes(loadTestAssetsAsBytes("home_demarches.json"), 200);
    });
    final repository = UserActionPERepository("BASE_URL", httpClient);

    // When
    final HomeDemarches? result = await repository.getHomeDemarches("UID");

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
    expect(result?.actions.length, 5);
    expect(
      result?.actions.first,
      UserActionPE(
        id: "8802034",
        content: "Faire le CV",
        status: UserActionPEStatus.NOT_STARTED,
        endDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
        deletionDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
        createdByAdvisor: true,
      ),
    );
    expect(
      result?.actions[1],
      UserActionPE(
        id: "8392839",
        content: "Compléter son CV",
        status: UserActionPEStatus.IN_PROGRESS,
        endDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
        deletionDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
        createdByAdvisor: true,
      ),
    );
  });

  test('get home démarches pôle emploi when response is invalid should return null', () async {
    // Given
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = UserActionPERepository("BASE_URL", httpClient);

    // When
    final search = await repository.getHomeDemarches("UserID");

    // Then
    expect(search, isNull);
  });
}
