import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_actions.dart';
import 'package:pass_emploi_app/models/conseiller.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/rendezvous_list_result.dart';
import 'package:pass_emploi_app/repositories/rendezvous/rendezvous_repository.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/sut_dio_repository.dart';
import '../../utils/test_datetime.dart';

void main() {
  final sut = DioRepositorySut<RendezvousRepository>();
  sut.givenRepository((client) => RendezvousRepository(client));

  group('getRendezvousList', () {
    group('on past', () {
      sut.when((repository) => repository.getRendezvousList('userID', RendezvousPeriod.PASSE));

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: 'rendezvous.json');

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: '/v2/jeunes/userID/rendezvous?periode=PASSES',
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<RendezvousListResult?>((result) {
            expect(result, isNotNull);
            expect(result!.rendezvous.length, 3);
            expect(result.rendezvous[0], mockRendezvousMiloCV());
            expect(
              result.rendezvous[1],
              Rendezvous(
                id: '2d663392-b9ff-4b20-81ca-70a3c779e300',
                source: RendezvousSource.passEmploi,
                date: parseDateTimeUtcWithCurrentTimeZone('2021-11-29T13:34:00.000Z'),
                modality: null,
                isInVisio: false,
                duration: 23,
                withConseiller: false,
                isAnnule: false,
                type: RendezvousType(RendezvousTypeCode.VISITE, 'Visite'),
                organism: 'Entreprise Bio Carburant',
                address: '1 rue de la Boétie, 67000 Strasbourg',
                precision: 'Visite',
              ),
            );
            expect(
              result.rendezvous[2].date,
              parseDateTimeUnconsideringTimeZone('2001-01-17T03:43:00.000Z'),
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

    group('on future', () {
      sut.when((repository) => repository.getRendezvousList('userID', RendezvousPeriod.FUTUR));

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: 'rendezvous.json');

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: '/v2/jeunes/userID/rendezvous?periode=FUTURS',
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<RendezvousListResult?>((result) {
            expect(result, isNotNull);
            expect(result!.rendezvous.length, 3);
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

    group('for Pôle Emploi rendezvous', () {
      sut.givenJsonResponse(fromJson: 'rendezvous_pole_emploi.json');

      sut.when((repository) => repository.getRendezvousList('userID', RendezvousPeriod.PASSE));

      test('retrieve rendezvous list correctly', () async {
        await sut.expectResult<RendezvousListResult?>((result) {
          expect(result, isNotNull);
          expect(result!.dateDerniereMiseAJour, parseDateTimeUtcWithCurrentTimeZone('2023-01-01T00:00:00.000Z'));
          expect(result.rendezvous.length, 10);
          expect(result.rendezvous[0].organism, 'Agence France Travail');
          expect(
            result.rendezvous[0],
            Rendezvous(
              id: '4995ea8a-4f6a-48be-925e-f45593c481f6',
              source: RendezvousSource.passEmploi,
              date: parseDateTimeUtcWithCurrentTimeZone('2021-11-28T13:34:00.000Z'),
              title: 'Super titre',
              modality: 'par visio',
              withConseiller: null,
              isAnnule: true,
              isInVisio: true,
              type: RendezvousType(RendezvousTypeCode.PRESTATION, 'Prestation'),
              duration: null,
              address: '11 RUE Paul Vimereu  80142 ABBEVILLE',
              organism: 'Agence France Travail',
              phone: '01.02.03.04.05',
              theme: 'Activ\'Projet',
              description: 'J\'explore des pistes professionnelles.',
              visioRedirectUrl: 'http://www.visio.fr',
            ),
          );
        });
      });

      test('an organism should be more important than an agence Pole Emploi', () async {
        await sut.expectResult<RendezvousListResult?>((result) {
          expect(result, isNotNull);
          expect(result!.rendezvous.length, 10);
          expect(result.rendezvous[4].organism, 'MBCCE');
        });
      });

      test('an agence Pole Emploi should be an organism', () async {
        await sut.expectResult<RendezvousListResult?>((result) {
          expect(result, isNotNull);
          expect(result!.rendezvous.length, 10);
          expect(result.rendezvous[0].organism, 'Agence France Travail');
        });
      });
    });
  });

  group('getRendezvousMilo', () {
    sut.when((repository) => repository.getRendezvousMilo('userID', 'rdvID'));

    group('when response is valid', () {
      sut.givenJsonResponse(fromJson: "rendezvous-detail.json");

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: HttpMethod.get,
          url: "/jeunes/userID/rendezvous/rdvID",
        );
      });
    });

    group('when response is invalid', () {
      sut.givenResponseCode(500);

      test('response should be null', () async {
        await sut.expectNullResult();
      });
    });
  });

  group('specific use cases', () {
    group('if conseiller and createur are same', () {
      sut.when((repository) => repository.getRendezvousMilo('userID', 'rdvID'));
      sut.givenJsonResponse(fromJson: 'rendezvous_where_conseiller_is_createur.json');
      test('should functionally return a null createur', () async {
        await sut.expectResult<Rendezvous?>((result) {
          expect(result!.conseiller, Conseiller(id: '1', firstName: 'Nils', lastName: 'Tavernier'));
          expect(result.createur, isNull);
        });
      });
    });

    group('if type is unknown', () {
      sut.when((repository) => repository.getRendezvousMilo('userID', 'rdvID'));
      sut.givenJsonResponse(fromJson: 'rendezvous_with_unknown_type.json');
      test('should fallback to "Autre" rendezvous type', () async {
        await sut.expectResult<Rendezvous?>((result) {
          expect(result, isNotNull);
          expect(result!.type, RendezvousType(RendezvousTypeCode.AUTRE, 'Entretien fin de CEJ'));
        });
      });
    });
  });
}
