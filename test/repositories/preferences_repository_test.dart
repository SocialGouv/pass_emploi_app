import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/preferences.dart';
import 'package:pass_emploi_app/repositories/preferences_repository.dart';

import '../dsl/sut_dio_repository.dart';

void main() {
  group('PreferencesRepository', () {
    final sut = DioRepositorySut<PreferencesRepository>();
    sut.givenRepository((client) => PreferencesRepository(client));

    group('getPreferences', () {
      sut.when(
        (repository) => repository.getPreferences("UID"),
      );

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "preferences.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/jeunes/UID/preferences",
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<Preferences?>((result) {
            expect(
              result,
              Preferences(
                partageFavoris: true,
                pushNotificationAlertesOffres: false,
                pushNotificationMessages: true,
                pushNotificationCreationAction: true,
                pushNotificationRendezvousSessions: false,
                pushNotificationRappelActions: true,
              ),
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

    group('updatePreferences', () {
      sut.when(
        (repository) => repository.updatePreferences("UID", true),
      );

      group('when response is valid', () {
        sut.givenResponseCode(200);

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.put,
            url: "/jeunes/UID/preferences",
            jsonBody: {'partageFavoris': true},
          );
        });

        test('response should be true', () async {
          await sut.expectTrueAsResult();
        });
      });

      group('when response is invalid', () {
        sut.givenResponseCode(500);

        test('response should be false', () async {
          await sut.expectFalseAsResult();
        });
      });
    });
  });
}
