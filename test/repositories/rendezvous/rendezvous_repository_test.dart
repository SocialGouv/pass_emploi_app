import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/models/conseiller.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/repositories/rendezvous/rendezvous_repository.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../utils/test_assets.dart';
import '../../utils/test_datetime.dart';

void main() {
  test('getRendezvous when response is valid should return rendezvous with date on local timezone', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != 'GET') return invalidHttpResponse();
      if (request.url.toString() != 'BASE_URL/jeunes/userId/rendezvous') return invalidHttpResponse();
      return Response.bytes(loadTestAssetsAsBytes('rendezvous.json'), 200);
    });
    final repository = RendezvousRepository('BASE_URL', httpClient, HeadersBuilderStub());

    // When
    final rendezvous = await repository.getRendezvous('userId');

    // Then
    expect(rendezvous, isNotNull);
    expect(rendezvous!.length, 2);
    expect(
      rendezvous[0],
      Rendezvous(
        id: '2d663392-b9ff-4b20-81ca-70a3c779e299',
        date: parseDateTimeUtcWithCurrentTimeZone('2021-11-28T13:34:00.000Z'),
        title: 'Nils Tavernier',
        modality: 'en présentiel : Misson locale / Permanence',
        duration: 23,
        withConseiller: true,
        type: RendezvousType(RendezvousTypeCode.ENTRETIEN_INDIVIDUEL_CONSEILLER, 'Entretien individuel conseiller'),
        comment: 'Amener votre CV',
        conseiller: Conseiller(id: '1', firstName: 'Nils', lastName: 'Tavernier'),
      ),
    );
    expect(
      rendezvous[1],
      Rendezvous(
        id: '2d663392-b9ff-4b20-81ca-70a3c779e300',
        date: parseDateTimeUtcWithCurrentTimeZone('2021-11-29T13:34:00.000Z'),
        title: 'title',
        modality: 'La visite se fera en présentiel',
        duration: 23,
        withConseiller: false,
        type: RendezvousType(RendezvousTypeCode.VISITE, 'Visite'),
        organism: 'Entreprise Bio Carburant',
        address: '1 rue de la Boétie, 67000 Strasbourg',
        precision: 'Visite',
      ),
    );
  });

  test('getRendezvous when response is valid with unknown type should fallback to "Autre" rendezvous type', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != 'GET') return invalidHttpResponse();
      if (request.url.toString() != 'BASE_URL/jeunes/userId/rendezvous') return invalidHttpResponse();
      return Response.bytes(loadTestAssetsAsBytes('rendezvous_with_unknown_type.json'), 200);
    });
    final repository = RendezvousRepository('BASE_URL', httpClient, HeadersBuilderStub());

    // When
    final rendezvous = await repository.getRendezvous('userId');

    // Then
    expect(rendezvous, isNotNull);
    expect(
      rendezvous!.first.type,
      RendezvousType(RendezvousTypeCode.AUTRE, 'Entretien fin de CEJ'),
    );
  });

  test('getRendezvous when response is invalid should return null', () async {
    // Given
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = RendezvousRepository('BASE_URL', httpClient, HeadersBuilderStub());

    // When
    final rendezvous = await repository.getRendezvous('userID');

    // Then
    expect(rendezvous, isNull);
  });

  test('getRendezvous when response throws exception should return null', () async {
    // Given
    final httpClient = MockClient((request) async => throw Exception());
    final repository = RendezvousRepository('BASE_URL', httpClient, HeadersBuilderStub());

    // When
    final rendezvous = await repository.getRendezvous('userID');

    // Then
    expect(rendezvous, isNull);
  });
}
