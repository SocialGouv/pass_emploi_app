import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/page_actions.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/repositories/page_action_repository.dart';

import '../doubles/fixtures.dart';
import '../utils/pass_emploi_mock_client.dart';
import '../utils/test_assets.dart';
import '../utils/test_datetime.dart';

class SUT<REPO> {
  late Response _response;
  late Request _request;
  late REPO _repository;
  late Future<bool> Function(REPO) _when;

  void givenResponse({required String fromJson}) {
    _response = Response.bytes(loadTestAssetsAsBytes(fromJson), 200);
  }

  void given201Response() {
    _response = Response('', 201);
  }

  void givenInvalidResponse() {
    _response = invalidHttpResponse();
  }

  Client _makeClient() {
    return PassEmploiMockClient((request) async {
      _request = request;
      return _response;
    });
  }

  void givenRepository(REPO Function(Client) createRepository) {
    _repository = createRepository(_makeClient());
  }

  void when(Future<bool> Function(REPO) when) {
    _when = when;
  }

  void expectRequestBody({required String method, required String url, Map<String, dynamic>? params}) async {
    await _when(_repository);

    expect(_request.method, method);
    expect(_request.url.toString(), url);

    if (params != null) expect(jsonUtf8Decode(_request.bodyBytes), params);
  }

  void expectResult(Function(bool) expectLambda) async {
    expectLambda(await _when(_repository));
  }
}

void main() {
  // Note : on n'écrit plus de boilerplate sur le client, ni sur la réponse
  // Note : on a des erreurs compréhensible et visible quand la requête est malformée
  // Note : on pourrait facilement faire un groupe avec des repository qui fail, et faire à l'intérieur tout les test de chaque route qui fail
  // Note : on écrit deux tests dans un groupe, un pour vérifier le contenu de la requiête qui est envoyée, l'autre pour le résultat : parce qu'un test n'a qu'une seule raison de fail

  group('PoC createUserAction', () {
    final sut = SUT<PageActionRepository>();

    group('when response is valid', () {
      sut.given201Response();
      sut.givenRepository((client) => PageActionRepository("BASE_URL", client));

      sut.when(
        (repository) => repository.createUserAction(
          "UID",
          UserActionCreateRequest("content", "comment", DateTime.utc(2022, 1, 1), true, UserActionStatus.DONE),
        ),
      );

      test('request should be valid', () {
        sut.expectRequestBody(
          method: "POST",
          url: "BASE_URL/jeunes/UID/action",
          params: {
            "content": "content",
            "comment": "comment",
            "status": "done",
            "rappel": true,
            "dateEcheance": "2022-01-01T00:00:00+00:00",
          }
        );
      });

      test('response should be valid', () {
        sut.expectResult((result) {
          expect(result, isTrue);
        });
      });
    });
  });

  group('getPageActions', () {
    test('when response is valid', () async {
      // Given
      final httpClient = PassEmploiMockClient((request) async {
        if (request.method != "GET") return invalidHttpResponse();
        if (!request.url.toString().startsWith("BASE_URL/jeunes/UID/home/actions")) return invalidHttpResponse();
        return Response.bytes(loadTestAssetsAsBytes("home_actions.json"), 200);
      });
      final repository = PageActionRepository("BASE_URL", httpClient);

      // When
      final PageActions? result = await repository.getPageActions("UID");

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
          dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-07-22T13:11:00.000Z"),
          creator: JeuneActionCreator(),
        ),
      );
      expect(
        result?.actions[1],
        UserAction(
          id: "8392839",
          content: "Compléter son CV",
          comment: "",
          status: UserActionStatus.IN_PROGRESS,
          dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2041-07-19T10:00:00.000Z"),
          creator: ConseillerActionCreator(name: "Nils Tavernier"),
        ),
      );
    });

    test('when response is invalid should return null', () async {
      // Given
      final httpClient = PassEmploiMockClient((request) async => invalidHttpResponse());
      final repository = PageActionRepository("BASE_URL", httpClient);

      // When
      final search = await repository.getPageActions("UserID");

      // Then
      expect(search, isNull);
    });
  });

  group('createUserAction', () {
    test('when response is valid', () async {
      // Given
      final httpClient = PassEmploiMockClient((request) async {
        if (request.method != "POST") return invalidHttpResponse();
        if (!request.url.toString().startsWith("BASE_URL/jeunes/UID/action")) return invalidHttpResponse();
        final requestJson = jsonUtf8Decode(request.bodyBytes);
        if (requestJson['content'] != 'content') return invalidHttpResponse();
        if (requestJson['comment'] != 'comment') return invalidHttpResponse();
        if (requestJson['status'] != 'done') return invalidHttpResponse();
        if (requestJson['rappel'] != true) return invalidHttpResponse();
        if (requestJson['dateEcheance'] != '2022-01-01T00:00:00+00:00') return invalidHttpResponse();
        return Response('', 201);
      });
      final repository = PageActionRepository("BASE_URL", httpClient);

      // When
      final result = await repository.createUserAction(
        "UID",
        UserActionCreateRequest("content", "comment", DateTime.utc(2022, 1, 1), true, UserActionStatus.DONE),
      );

      // Then
      expect(result, isTrue);
    });

    test('when response is valid should return false', () async {
      // Given
      final httpClient = PassEmploiMockClient((request) async => invalidHttpResponse());
      final repository = PageActionRepository("BASE_URL", httpClient);

      // When
      final result = await repository.createUserAction(
        "UID",
        UserActionCreateRequest("content", "comment", DateTime(2022, 1, 1), true, UserActionStatus.DONE),
      );

      // Then
      expect(result, isFalse);
    });
  });
}
