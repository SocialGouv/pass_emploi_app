import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/models/requests/user_action_update_request.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';

import '../dsl/sut_dio_repository.dart';
import '../utils/test_datetime.dart';

void main() {
  group('UserActionRepository', () {
    final sut = DioRepositorySut<UserActionRepository>();
    sut.givenRepository((client) => UserActionRepository(client));

    group('getUserAction', () {
      sut.when((pageActionRepository) => pageActionRepository.getUserAction('actionId'));

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "user_action.json");

        test('request should be valid', () {
          sut.expectRequestBody(method: HttpMethod.get, url: '/actions/actionId');
        });

        test('result should be valid', () {
          sut.expectResult<UserAction?>((result) {
            expect(
              result,
              UserAction(
                id: "8802034",
                content: "Changer de prénom",
                comment: "Commentaire",
                status: UserActionStatus.NOT_STARTED,
                dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-07-22T13:11:00.000Z"),
                qualificationStatus: UserActionQualificationStatus.QUALIFIEE,
                creationDate: DateTime(2021),
                creator: JeuneActionCreator(),
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

    group('createUserAction', () {
      sut.when(
        (repository) => repository.createUserAction(
          "UID",
          UserActionCreateRequest(
            "content",
            "comment",
            DateTime.utc(2022, 1, 1),
            true,
            UserActionStatus.DONE,
            UserActionReferentielType.emploi,
          ),
        ),
      );

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "create_action.json");

        test('request should be valid', () {
          sut.expectRequestBody(
            method: HttpMethod.post,
            url: "/jeunes/UID/action",
            jsonBody: {
              "content": "content",
              "comment": "comment",
              "status": "done",
              "rappel": true,
              "dateEcheance": "2022-01-01T00:00:00+00:00",
              "codeQualification": "EMPLOI",
            },
          );
        });

        test('result should be UserAction created ID', () {
          sut.expectResult<String?>((result) {
            expect(result, "ACTION-ID");
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

    group('deleteUserAction', () {
      sut.when((repository) => repository.deleteUserAction("UID"));

      group('when response is valid', () {
        sut.givenResponseCode(201);

        test('request should be valid', () {
          sut.expectRequestBody(method: HttpMethod.delete, url: "/actions/UID");
        });

        test('result should be true', () {
          sut.expectTrueAsResult();
        });
      });
      group('when response is invalid', () {
        sut.givenResponseCode(500);

        test('result should be false', () {
          sut.expectFalseAsResult();
        });
      });
    });

    group('updateUserAction', () {
      sut.when(
        (repository) => repository.updateUserAction(
          "UID",
          UserActionUpdateRequest(
            status: UserActionStatus.NOT_STARTED,
            contenu: "titre",
            description: "description",
            dateEcheance: DateTime.utc(2024),
            type: UserActionReferentielType.emploi,
          ),
        ),
      );

      group('when response is valid', () {
        sut.givenResponseCode(201);

        test('request should be valid', () {
          sut.expectRequestBody(
            method: HttpMethod.put,
            url: "/actions/UID",
            jsonBody: {
              "status": "not_started",
              "contenu": "titre",
              "description": "description",
              "dateEcheance": "2024-01-01T00:00:00+00:00",
              "codeQualification": "EMPLOI"
            },
          );
        });

        test('result should be true', () {
          sut.expectTrueAsResult();
        });
      });
      group('when response is invalid', () {
        sut.givenResponseCode(500);

        test('result should be false', () {
          sut.expectFalseAsResult();
        });
      });
    });
  });
}
