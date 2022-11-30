import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_actions.dart';
import 'package:pass_emploi_app/models/conseiller.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/repositories/rendezvous/rendezvous_repository.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/sut_repository.dart';
import '../../utils/pass_emploi_mock_client.dart';
import '../../utils/test_assets.dart';
import '../../utils/test_datetime.dart';

void main() {
  group('getRendezvousList should return rendezvous list', () {
    void expectRendezvousResult({required String andExpectedUrl, required RendezvousPeriod forPerdiod}) async {
      // Given
      final httpClient = PassEmploiMockClient((request) async {
        if (request.method != 'GET') return invalidHttpResponse();
        if (request.url.toString() != andExpectedUrl) return invalidHttpResponse();
        return Response.bytes(loadTestAssetsAsBytes('rendezvous.json'), 200);
      });
      final repository = RendezvousRepository('BASE_URL', httpClient);

      // When
      final rendezvous = await repository.getRendezvousList('userId', forPerdiod);

      // Then
      expect(rendezvous, isNotNull);
      expect(rendezvous!.length, 3);
      expect(
        rendezvous[0],
        Rendezvous(
          id: '2d663392-b9ff-4b20-81ca-70a3c779e299',
          date: parseDateTimeUtcWithCurrentTimeZone('2021-11-28T13:34:00.000Z'),
          modality: 'en présentiel : Misson locale / Permanence',
          isInVisio: false,
          duration: 23,
          withConseiller: true,
          isAnnule: false,
          type: RendezvousType(RendezvousTypeCode.ENTRETIEN_INDIVIDUEL_CONSEILLER, 'Entretien individuel conseiller'),
          title: "super entretien",
          comment: 'Amener votre CV',
          conseiller: Conseiller(id: '1', firstName: 'Nils', lastName: 'Tavernier'),
          createur: Conseiller(id: '2', firstName: 'Joe', lastName: 'Pesci'),
        ),
      );
      expect(
        rendezvous[1],
        Rendezvous(
          id: '2d663392-b9ff-4b20-81ca-70a3c779e300',
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
        rendezvous[2].date,
        parseDateTimeUnconsideringTimeZone('2001-01-17T03:43:00.000Z'),
      );
    }

    test('on past', () async {
      expectRendezvousResult(
        andExpectedUrl: 'BASE_URL/jeunes/userId/rendezvous?periode=PASSES',
        forPerdiod: RendezvousPeriod.PASSE,
      );
    });

    test('on future', () async {
      expectRendezvousResult(
        andExpectedUrl: 'BASE_URL/jeunes/userId/rendezvous?periode=FUTURS',
        forPerdiod: RendezvousPeriod.FUTUR,
      );
    });
  });

  test('a rendezvous where conseiller and createur is same in payload should fonctionnaly return a null createur',
      () async {
        final httpClient = PassEmploiMockClient((request) async {
      return Response.bytes(loadTestAssetsAsBytes('rendezvous_where_conseiller_is_createur.json'), 200);
    });
    final repository = RendezvousRepository('BASE_URL', httpClient);

    final rendezvous = await repository.getRendezvousList('userId', RendezvousPeriod.FUTUR);

    expect(rendezvous!.first.conseiller, Conseiller(id: '1', firstName: 'Nils', lastName: 'Tavernier'));
    expect(rendezvous.first.createur, isNull);
  });

  test('an organism should be more important than an agence Pole Emploi', () async {
    final repository = _rendezvousFutursRepositoryFromPoleEmploi();

    final rendezvous = await repository.getRendezvousList('userId', RendezvousPeriod.FUTUR);

    expect(rendezvous, isNotNull);
    expect(rendezvous!.length, 10);
    expect(rendezvous[4].organism, "MBCCE");
  });

  test('an agence Pole Emploi should be an organism', () async {
    final repository = _rendezvousFutursRepositoryFromPoleEmploi();

    final rendezvous = await repository.getRendezvousList('userId', RendezvousPeriod.FUTUR);

    expect(rendezvous, isNotNull);
    expect(rendezvous!.length, 10);
    expect(rendezvous[0].organism, "Agence Pôle Emploi");
  });

  test('getRendezvousList when response is valid with Pole Emploi rendezvous', () async {
    final repository = _rendezvousFutursRepositoryFromPoleEmploi();

    final rendezvous = await repository.getRendezvousList('userId', RendezvousPeriod.FUTUR);

    expect(rendezvous, isNotNull);
    expect(rendezvous!.length, 10);
    expect(rendezvous[0].organism, "Agence Pôle Emploi");
    expect(
      rendezvous[0],
      Rendezvous(
        id: '4995ea8a-4f6a-48be-925e-f45593c481f6',
        date: parseDateTimeUtcWithCurrentTimeZone('2021-11-28T13:34:00.000Z'),
        title: "Super titre",
        modality: 'par visio',
        withConseiller: null,
        isAnnule: true,
        isInVisio: true,
        type: RendezvousType(RendezvousTypeCode.PRESTATION, 'Prestation'),
        duration: null,
        address: '11 RUE Paul Vimereu  80142 ABBEVILLE',
        organism: 'Agence Pôle Emploi',
        phone: '01.02.03.04.05',
        theme: 'Activ\'Projet',
        description: 'J\'explore des pistes professionnelles.',
        visioRedirectUrl: 'http://www.visio.fr',
      ),
    );
  });

  test('getRendezvousList when response is valid with unknown type should fallback to "Autre" rendezvous type',
      () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async {
      if (request.method != 'GET') return invalidHttpResponse();
      if (request.url.toString() != 'BASE_URL/jeunes/userId/rendezvous?periode=FUTURS') return invalidHttpResponse();
      return Response.bytes(loadTestAssetsAsBytes('rendezvous_with_unknown_type.json'), 200);
    });
    final repository = RendezvousRepository('BASE_URL', httpClient);

    // When
    final rendezvous = await repository.getRendezvousList('userId', RendezvousPeriod.FUTUR);

    // Then
    expect(rendezvous, isNotNull);
    expect(
      rendezvous!.first.type,
      RendezvousType(RendezvousTypeCode.AUTRE, 'Entretien fin de CEJ'),
    );
  });

  test('getRendezvousList when response is invalid should return null', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async => invalidHttpResponse());
    final repository = RendezvousRepository('BASE_URL', httpClient);

    // When
    final rendezvous = await repository.getRendezvousList('userID', RendezvousPeriod.FUTUR);

    // Then
    expect(rendezvous, isNull);
  });

  test('getRendezvousList when response throws exception should return null', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async => throw Exception());
    final repository = RendezvousRepository('BASE_URL', httpClient);

    // When
    final rendezvous = await repository.getRendezvousList('userID', RendezvousPeriod.FUTUR);

    // Then
    expect(rendezvous, isNull);
  });

  group('getRendezvous', () {
    final sut = RepositorySut<RendezvousRepository>();
    sut.givenRepository((client) => RendezvousRepository('BASE_URL', client));

    sut.when(
      (repository) => repository.getRendezvous('userID', 'rdvID'),
    );

    group('when response is valid', () {
      sut.givenJsonResponse(fromJson: "rendezvous-detail.json");

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: "GET",
          url: "BASE_URL/jeunes/userID/rendezvous/rdvID",
        );
      });

      test('response should be valid', () async {
        await sut.expectResult<Rendezvous?>((result) {
          expect(result, isNotNull);
          expect(
            result,
            Rendezvous(
              id: '2d663392-b9ff-4b20-81ca-70a3c779e299',
              date: parseDateTimeUtcWithCurrentTimeZone('2021-11-28T13:34:00.000Z'),
              modality: 'en présentiel : Misson locale / Permanence',
              isInVisio: false,
              duration: 23,
              withConseiller: true,
              isAnnule: false,
              type:
                  RendezvousType(RendezvousTypeCode.ENTRETIEN_INDIVIDUEL_CONSEILLER, 'Entretien individuel conseiller'),
              title: "super entretien",
              comment: 'Amener votre CV',
              conseiller: Conseiller(id: '1', firstName: 'Nils', lastName: 'Tavernier'),
              createur: Conseiller(id: '2', firstName: 'Joe', lastName: 'Pesci'),
              estInscrit: true,
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
}

RendezvousRepository _rendezvousFutursRepositoryFromPoleEmploi() {
  final httpClient = PassEmploiMockClient((request) async {
    if (request.method != 'GET') return invalidHttpResponse();
    if (request.url.toString() != 'BASE_URL/jeunes/userId/rendezvous?periode=FUTURS') return invalidHttpResponse();
    return Response.bytes(loadTestAssetsAsBytes('rendezvous_pole_emploi.json'), 200);
  });
  return RendezvousRepository('BASE_URL', httpClient);
}
