import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/session_milo.dart';
import 'package:pass_emploi_app/models/session_milo_details.dart';
import 'package:pass_emploi_app/repositories/session_milo_repository.dart';

import '../doubles/fixtures.dart';
import '../dsl/sut_dio_repository.dart';

void main() {
  group('SessionMiloRepository', () {
    final sut = DioRepositorySut<SessionMiloRepository>();
    sut.givenRepository((client) => SessionMiloRepository(client));

    group('getList with filtre est inscrit', () {
      sut.when((repository) => repository.getList(userId: "userId", filtrerEstInscrit: true));

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "session_milo_list.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/jeunes/milo/userId/sessions?filtrerEstInscrit=true",
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

    group('getList with filtre n\'est pas inscrit', () {
      sut.when((repository) => repository.getList(userId: "userId", filtrerEstInscrit: false));

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "session_milo_list.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/jeunes/milo/userId/sessions?filtrerEstInscrit=false",
          );
        });
      });
    });
    

    group('getList without filtre', () {
      sut.when((repository) => repository.getList(userId: "userId"));

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "session_milo_list.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/jeunes/milo/userId/sessions",
          );
        });
      });
    });
    
    group('getDetails', () {
      group('get', () {
        sut.when((repository) => repository.getDetails(userId: "userId", sessionId: "sessionId"));

        group('when response is valid', () {
          sut.givenJsonResponse(fromJson: "session_milo_details.json");

          test('request should be valid', () async {
            await sut.expectRequestBody(
              method: HttpMethod.get,
              url: "/jeunes/milo/userId/sessions/sessionId",
            );
          });

          test('response should be valid', () async {
            await sut.expectResult<SessionMiloDetails?>((sessionMilo) {
              expect(sessionMilo, isNotNull);

              expect(sessionMilo, mockSessionMiloDetails());
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
  });
}
