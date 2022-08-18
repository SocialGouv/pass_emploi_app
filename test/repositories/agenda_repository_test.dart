import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/agenda.dart';
import 'package:pass_emploi_app/repositories/agenda_repository.dart';

import '../dsl/sut_repository.dart';

void main() {
  group('AgendaRepository', () {
    final sut = SUT<AgendaRepository>();
    sut.givenRepository((client) => AgendaRepository("BASE_URL", client));

    group('getAgenda', () {
      sut.when(
        (repository) => repository.getAgenda(
          "UID",
          DateTime.utc(2022, 7, 7),
        ),
      );

      group('when response is valid', () {
        sut.givenResponse(fromJson: "agenda.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: "GET",
            url: "BASE_URL/jeunes/UID/home/agenda?maintenant=2022-07-07T00:00:00+00:00",
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<Agenda?>((result) {
            expect(result, isNotNull);
            expect(result?.actions.length, 1);
            expect(result?.actions.first.id, "6fb6fe3b-5ee5-4b67-8372-31457fc78947");
            expect(result?.rendezVous.length, 1);
            expect(result?.rendezVous.first.id, "145631e8-7230-4b04-bcfc-d48ec358689a");
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
