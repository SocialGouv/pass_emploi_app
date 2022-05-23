import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/home_actions.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';

import '../doubles/fixtures.dart';
import '../utils/test_assets.dart';
import '../utils/test_datetime.dart';

void main() {
  test('get page action', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/jeunes/UID/home/actions")) return invalidHttpResponse();
      return Response.bytes(loadTestAssetsAsBytes("home_actions.json"), 200);
    });
    final repository = UserActionRepository("BASE_URL", httpClient);

    // When
    final HomeActions? result = await repository.getHomeActions("UID");

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
    expect(result?.actions.length, 2);
    expect(
      result?.actions[0],
      UserAction(
          id: "8802034",
          content: "Changer de prénom",
          comment: "Commentaire",
          status: UserActionStatus.NOT_STARTED,
          lastUpdate: parseDateTimeWithCurrentTimeZone("Fri, 30 Jul 2021 09:43:09 GMT"),
          creator: JeuneActionCreator()),
    );
    expect(
      result?.actions[1],
      UserAction(
          id: "8392839",
          content: "Compléter son CV",
          comment: "",
          status: UserActionStatus.IN_PROGRESS,
          lastUpdate: parseDateTimeWithCurrentTimeZone("Fri, 24 Jul 2021 19:11:10 GMT"),
          creator: ConseillerActionCreator(name: "Nils Tavernier")),
    );
  });

  test('get home actions when response is invalid should return null', () async {
    // Given
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = UserActionRepository("BASE_URL", httpClient);

    // When
    final search = await repository.getHomeActions("UserID");

    // Then
    expect(search, isNull);
  });
}
