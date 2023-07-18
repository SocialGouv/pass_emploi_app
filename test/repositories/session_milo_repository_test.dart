import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/details_session_milo.dart';
import 'package:pass_emploi_app/models/session_milo.dart';
import 'package:pass_emploi_app/repositories/session_milo_repository.dart';

import '../doubles/fixtures.dart';
import '../dsl/sut_dio_repository.dart';

void main() {
  group('SessionMiloRepository', () {
    final sut = DioRepositorySut<SessionMiloRepository>();
    sut.givenRepository((client) => SessionMiloRepository(client));

    group('getList', () {
      sut.when((repository) => repository.getList("userId"));

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "session_milo_list.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/jeunes/milo/userId/sessions",
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<List<SessionMilo>?>((sessions) {
            expect(sessions, [mockSessionMiloAtelierCv()]);
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
    group('getDetails', () {
      test("description", () => expect(DetailsSessionMilo(), isNotNull));
    });
  });
}
