import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/agenda.dart';
import 'package:pass_emploi_app/repositories/agenda_repository.dart';

import '../doubles/fixtures.dart';
import '../dsl/sut_repository.dart';
import '../utils/test_datetime.dart';

void main() {
  group('AgendaRepository', () {
    final sut = SUT<AgendaRepository>();
    sut.givenRepository((client) => AgendaRepository("BASE_URL", client));

    group('getAgendaMissionLocale', () {
      sut.when(
        (repository) => repository.getAgendaMissionLocale(
          "UID",
          DateTime.utc(2022, 7, 7),
        ),
      );

      group('when response is valid', () {
        sut.givenResponse(fromJson: "agenda_mission_locale.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: "GET",
            url: "BASE_URL/jeunes/UID/home/agenda?maintenant=2022-07-07T00%3A00%3A00%2B00%3A00",
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<Agenda?>((result) {
            expect(result, isNotNull);
            expect(
                result,
                Agenda(
                  actions: [userActionStub()],
                  demarches: [],
                  rendezvous: [rendezvousStub()],
                  delayedActions: 3,
                  dateDeDebut: parseDateTimeUtcWithCurrentTimeZone('2022-08-27T00:00:00.000Z'),
                ));
          });
        });
      });

      group('when response is invalid', () {
        sut.givenInvalidResponse();

        test('response should be null', () async {
          await sut.expectResult<Agenda?>((result) {
            expect(result, isNull);
          });
        });
      });
    });

    group('getAgendaPoleEmploi', () {
      sut.when(
        (repository) => repository.getAgendaPoleEmploi(
          "UID",
          DateTime.utc(2022, 7, 7),
        ),
      );

      group('when response is valid', () {
        sut.givenResponse(fromJson: "agenda_pole_emploi.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: "GET",
            url: "BASE_URL/jeunes/UID/home/agenda/pole-emploi?maintenant=2022-07-07T00%3A00%3A00%2B00%3A00",
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<Agenda?>((result) {
            expect(result, isNotNull);
            expect(
                result,
                Agenda(
                  actions: [],
                  demarches: [demarcheStub()],
                  rendezvous: [rendezvousStub()],
                  delayedActions: 3,
                  dateDeDebut: parseDateTimeUtcWithCurrentTimeZone('2022-08-27T00:00:00.000Z'),
                ));
          });
        });
      });

      group('when response is invalid', () {
        sut.givenInvalidResponse();

        test('response should be null', () async {
          await sut.expectResult<Agenda?>((result) {
            expect(result, isNull);
          });
        });
      });
    });
  });
}
