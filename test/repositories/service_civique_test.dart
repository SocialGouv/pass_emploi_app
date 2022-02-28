import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/repositories/service_civique_repository.dart';

import '../doubles/fixtures.dart';
import '../doubles/stubs.dart';
import '../utils/test_assets.dart';

void main() {
  test('search when response is valid with department location should return offres', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/services-civique")) return invalidHttpResponse();
      if (request.url.queryParameters["lat"] != "47.239367") return invalidHttpResponse();
      if (request.url.queryParameters["lon"] != "1.555335") return invalidHttpResponse();
      if (request.url.queryParameters["page"] != "0") return invalidHttpResponse();
      if (request.url.queryParameters["limit"] != "50") return invalidHttpResponse();
      return Response.bytes(loadTestAssetsAsBytes("service_civique_offres.json"), 200);
    });
    final repository = ServiceCiviqueRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final location = Location(
      libelle: "Nantes",
      code: "44300",
      type: LocationType.DEPARTMENT,
      latitude: 47.239367,
      longitude: 1.555335,
    );
    final search = await repository.search(
      userId: "ID",
      request: SearchServiceCiviqueRequest(
        location: location,
        startDate: '',
        domain: '',
        endDate: '',
        page: 0,
        distance: null,
      ),
      previousOffers: [],
    );

    // Then
    expect(search?.isMoreDataAvailable, false);
    expect(search?.offres.length, 2);
    final offre = search?.offres[0];
    expect(
      offre,
      ServiceCivique(
        id: "61dd6f4cd016777c442bd8c7",
        title: "Accompagnement des publics individuels",
        companyName: "SYNDICAT MIXTE DU CHATEAU DE VALENCAY",
        location: "Valençay",
        startDate: "01 décembre 2021",
        domain: "solidarite-insertion",
      ),
    );
  });


  test('search when response is invalid should return null', () async {
    // Given
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = ServiceCiviqueRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final search = await repository.search(
      userId: "ID",
      request: SearchServiceCiviqueRequest(
        location: mockLocation(),
        startDate: '',
        domain: '',
        endDate: '',
        page: 0,
        distance: null,
      ),
      previousOffers: [],
    );

    // Then
    expect(search, isNull);
  });
}
