import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/page_actions.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/repositories/page_action_repository.dart';

import '../doubles/dio_mock.dart';
import '../dsl/sut_repository2.dart';
import '../utils/test_assets.dart';
import '../utils/test_datetime.dart';

//TODO: to remove/merge
void main() {
  group('PageActionRepository2', () {
    final sut = RepositorySut2<PageActionRepository>();
    sut.givenRepository((client) => PageActionRepository(client));

    group('getPageActions', () {
      sut.when((pageActionRepository) => pageActionRepository.getPageActions("uuid"));

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "home_actions.json");

        test('result should be valid', () {
          sut.expectRequestBody(method: HttpMethod.get, url: "/jeunes/uuid/home/actions");
        });

        test('result should be valid', () {
          // THEN
          sut.expectResult<PageActions?>((result) {
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
        });
      });

      group('when response is invalid', () {
        sut.givenResponseCode(500);

        test('result should be null', () {
          sut.expectNullResult();
        });
      });
    });
  });

  test("test avec mocktail", () async {
    // Given
    final dio = DioMock();
    final options = RequestOptions(path: "path");
    final data = jsonDecode(loadTestAssets("home_actions.json"));
    final response = Response(requestOptions: options, data: data);
    when(() => dio.get(any())).thenAnswer((_) async => response);
    final repo = PageActionRepository(dio);
    // When
    final result = await repo.getPageActions("JOCH");
    // Then
    final captured = verify(() => dio.get(captureAny())).captured.last;
    expect(captured, "/jeunes/JOCH/home/actions");
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
}
