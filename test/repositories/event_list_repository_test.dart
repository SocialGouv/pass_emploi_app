import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/conseiller.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/repositories/event_list_repository.dart';

import '../dsl/sut_repository.dart';
import '../utils/test_datetime.dart';

void main() {
  group('EventListRepository', () {
    final sut = RepositorySut<EventListRepository>();
    sut.givenRepository((client) => EventListRepository("BASE_URL", client));

    group('getAgendaPoleEmploi', () {
      sut.when(
        (repository) => repository.get("UID", DateTime.utc(2022, 11, 5)),
      );

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "animations-collectives.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: "GET",
            url: "BASE_URL/jeunes/UID/animations-collectives?maintenant=2022-11-05T00%3A00%3A00%2B00%3A00",
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<List<Rendezvous>?>((result) {
            expect(result, isNotNull);
            expect(result?.length, 3);

            expect(
              result?[0],
              Rendezvous(
                id: '2d663392-b9ff-4b20-81ca-70a3c779e299',
                source: RendezvousSource.passEmploi,
                date: parseDateTimeUtcWithCurrentTimeZone('2021-11-28T13:34:00.000Z'),
                modality: 'en présentiel : Misson locale / Permanence',
                isInVisio: false,
                duration: 23,
                withConseiller: true,
                isAnnule: false,
                type: RendezvousType(
                    RendezvousTypeCode.ENTRETIEN_INDIVIDUEL_CONSEILLER, 'Entretien individuel conseiller'),
                title: "super entretien",
                comment: 'Amener votre CV',
                conseiller: Conseiller(id: '1', firstName: 'Nils', lastName: 'Tavernier'),
                createur: Conseiller(id: '2', firstName: 'Joe', lastName: 'Pesci'),
                estInscrit: true,
              ),
            );

            expect(result?[0].estInscrit, true);
            expect(result?[1].estInscrit, false);
            expect(result?[2].estInscrit, null);
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
