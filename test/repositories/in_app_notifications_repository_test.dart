import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/in_app_notification.dart';
import 'package:pass_emploi_app/repositories/in_app_notifications_repository.dart';

import '../dsl/sut_dio_repository.dart';
import '../utils/test_datetime.dart';

void main() {
  const String userId = "userId";
  group('InAppNotificationsRepository', () {
    final sut = DioRepositorySut<InAppNotificationsRepository>();
    sut.givenRepository((client) => InAppNotificationsRepository(client));

    group('get', () {
      sut.when((repository) => repository.get(userId));

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "notifications.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/jeunes/userId/notifications",
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<List<InAppNotification>?>((result) {
            expect(
              result,
              [
                InAppNotification(
                  id: "1",
                  titre: "Rendez-vous supprimé",
                  description: "Votre rendez-vous du 16/01/2024 a été supprime par votre conseiller.",
                  date: parseDateTimeUtcWithCurrentTimeZone("2022-07-22T13:11:00.000Z"),
                  type: InAppNotificationType.deletedRendezvous,
                  idObjet: "1",
                ),
                InAppNotification(
                  id: "2",
                  titre: "Rendez-vous modifié",
                  description: "Votre rendez-vous du 16/01/2024 a été modifié par votre conseiller.",
                  date: parseDateTimeUtcWithCurrentTimeZone("2022-07-22T13:11:00.000Z"),
                  type: InAppNotificationType.updatedRendezvous,
                  idObjet: "2",
                ),
                InAppNotification(
                  id: "3",
                  titre: "Nouveau rendez-vous",
                  description: "Votre conseiller à programmé un nouveau rendez-vous le 16/01/2024.",
                  date: parseDateTimeUtcWithCurrentTimeZone("2022-07-22T13:11:00.000Z"),
                  type: InAppNotificationType.newRendezvous,
                  idObjet: "3",
                ),
              ],
            );
          });
        });
      });

      group('when response is invalid', () {
        sut.givenResponseCode(500);

        test('response should be null', () async {
          await sut.expectNullResult();
        });
      });
    });
  });
}
