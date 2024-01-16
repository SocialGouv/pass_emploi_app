import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/mon_suivi.dart';
import 'package:pass_emploi_app/repositories/mon_suivi_repository.dart';

import '../doubles/fixtures.dart';
import '../dsl/sut_dio_repository.dart';

void main() {
  group('MonSuiviRepository', () {
    final sut = DioRepositorySut<MonSuiviRepository>();
    sut.givenRepository((client) => MonSuiviRepository(client));

    group('get', () {
      sut.when(
        (repository) => repository.getMonSuivi(userId: 'user-id', debut: DateTime(2024, 1), fin: DateTime(2024, 2)),
      );

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "agenda_mission_locale.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/jeunes/milo/user-id/mon-suivi",
            queryParameters: {"debut": DateTime(2024, 1), "fin": DateTime(2024, 2)},
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<MonSuivi?>((result) {
            expect(result, isNotNull);
            expect(
                result,
                MonSuivi(
                  actions: [userActionStub()],
                  rendezvous: [rendezvousStub()],
                  sessionsMilo: [mockSessionMiloAtelierCv()],
                ));
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
