import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/date/interval.dart';
import 'package:pass_emploi_app/models/mon_suivi.dart';
import 'package:pass_emploi_app/repositories/mon_suivi_repository.dart';

import '../doubles/fixtures.dart';
import '../dsl/sut_dio_repository.dart';
import '../utils/test_datetime.dart';

void main() {
  group('MonSuiviRepository', () {
    final sut = DioRepositorySut<MonSuiviRepository>();
    sut.givenRepository((client) => MonSuiviRepository(client));

    group('getMonSuiviMilo', () {
      group('get with complete payload', () {
        sut.when(
          (repository) => repository.getMonSuiviMilo('user-id', Interval(DateTime.utc(2024, 1), DateTime.utc(2024, 2))),
        );

        group('when response is valid', () {
          sut.givenJsonResponse(fromJson: "mon_suivi_mission_locale.json");

          test('request should be valid', () async {
            await sut.expectRequestBody(
              method: HttpMethod.get,
              url: "/jeunes/milo/user-id/mon-suivi",
              queryParameters: {
                "dateDebut": '2024-01-01T00:00:00+00:00',
                "dateFin": '2024-02-01T00:00:00+00:00',
              },
            );
          });

          test('response should be valid', () async {
            await sut.expectResult<MonSuivi?>((result) {
              expect(result, isNotNull);
              expect(
                result,
                MonSuivi(
                  actions: [userActionStub()],
                  demarches: [],
                  rendezvous: [rendezvousStub()],
                  sessionsMilo: [mockSessionMiloAtelierCv()],
                  errorOnSessionMiloRetrieval: false,
                  dateDerniereMiseAJourPoleEmploi: null,
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

      group('get null sessions milo in  payload', () {
        sut.when((repository) => repository.getMonSuiviMilo('user-id', Interval(DateTime(2024, 1), DateTime(2024, 2))));

        group('when response is valid', () {
          sut.givenJsonResponse(fromJson: "mon_suivi_mission_locale_null_sessions.json");

          test('response should be valid - for now, just fallback to empty array of sessions', () async {
            await sut.expectResult<MonSuivi?>((result) {
              expect(result, isNotNull);
              expect(
                result,
                MonSuivi(
                  actions: [userActionStub()],
                  demarches: [],
                  rendezvous: [rendezvousStub()],
                  sessionsMilo: [],
                  errorOnSessionMiloRetrieval: true,
                  dateDerniereMiseAJourPoleEmploi: null,
                ),
              );
            });
          });
        });
      });
    });

    group('getMonSuiviPoleEmploi', () {
      sut.when((repository) => repository.getMonSuiviPoleEmploi('user-id', DateTime.utc(2024, 1)));

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "mon_suivi_pole_emploi.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/jeunes/user-id/pole-emploi/mon-suivi",
            queryParameters: {"dateDebut": '2024-01-01T00:00:00+00:00'},
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<MonSuivi?>((result) {
            expect(result, isNotNull);
            expect(
              result,
              MonSuivi(
                actions: [],
                demarches: [demarcheStub()],
                rendezvous: [rendezvousStub()],
                sessionsMilo: [],
                errorOnSessionMiloRetrieval: false,
                dateDerniereMiseAJourPoleEmploi: null,
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

      group('get last update in  payload', () {
        sut.when((repository) => repository.getMonSuiviPoleEmploi('user-id', DateTime.utc(2024, 1)));

        group('when response is valid', () {
          sut.givenJsonResponse(fromJson: "mon_suivi_pole_emploi_date_derniere_maj.json");

          test('request should be valid', () async {
            await sut.expectRequestBody(
              method: HttpMethod.get,
              url: "/jeunes/user-id/pole-emploi/mon-suivi",
              queryParameters: {"dateDebut": '2024-01-01T00:00:00+00:00'},
            );
          });

          test('response should be valid', () async {
            await sut.expectResult<MonSuivi?>((result) {
              expect(result, isNotNull);
              expect(
                result!.dateDerniereMiseAJourPoleEmploi,
                parseDateTimeUtcWithCurrentTimeZone('2023-01-01T00:00:00.000Z'),
              );
            });
          });
        });
      });
    });
  });
}
