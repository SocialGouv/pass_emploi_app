import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/agenda.dart';
import 'package:pass_emploi_app/repositories/agenda_repository.dart';

import '../doubles/fixtures.dart';
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
            url: "BASE_URL/jeunes/UID/home/agenda?maintenant=2022-07-07T00%3A00%3A00%2B00%3A00",
          );
        });

        test('response should be valid', () async {
          mockRendezvous();
          mockUserAction();
          await sut.expectResult<Agenda?>((result) {
            expect(result, isNotNull);
            expect(result, Agenda(actions: [userActionStub()], rendezvous: [rendezvousStub()], delayedActions: 3));
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
