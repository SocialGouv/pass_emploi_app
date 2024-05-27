import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/conseiller.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/repositories/rendezvous/rendezvous_repository.dart';

import '../../dsl/sut_dio_repository.dart';
import '../../utils/test_datetime.dart';

void main() {
  final sut = DioRepositorySut<RendezvousRepository>();
  sut.givenRepository((client) => RendezvousRepository(client));

  group('getRendezvousPoleEmploi', () {
    group('when response is valid', () {
      sut.givenJsonResponse(fromJson: 'rendezvous_pole_emploi.json');

      sut.when((repository) => repository.getRendezvousPoleEmploi('userID', '4995ea8a-4f6a-48be-925e-f45593c481f6'));

      test('retrieve rendezvous list and filter on ID locally', () async {
        await sut.expectResult<Rendezvous?>((result) {
          expect(result, isNotNull);
          expect(
            result,
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
    });

    group('case where organism overrides agence', () {
      sut.givenJsonResponse(fromJson: 'rendezvous_pole_emploi.json');

      sut.when((repository) => repository.getRendezvousPoleEmploi('userID', '620e0dc7-7d4a-456c-95b6-ec11f4d4587d'));

      test('an organism should be more important than an agence Pole Emploi', () async {
        await sut.expectResult<Rendezvous?>((result) {
          expect(result, isNotNull);
          expect(result!.organism, 'MBCCE');
        });
      });
    });

    group('case where agence overrides organsim', () {
      sut.givenJsonResponse(fromJson: 'rendezvous_pole_emploi.json');

      sut.when((repository) => repository.getRendezvousPoleEmploi('userID', '4995ea8a-4f6a-48be-925e-f45593c481f6'));

      test('an agence Pole Emploi should be an organism', () async {
        await sut.expectResult<Rendezvous?>((result) {
          expect(result, isNotNull);
          expect(result!.organism, 'Agence France Travail');
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
