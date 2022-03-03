import 'dart:ffi';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/repositories/rendezvous_repository.dart';

import '../doubles/fixtures.dart';
import '../doubles/stubs.dart';
import '../utils/test_assets.dart';
import '../utils/test_datetime.dart';

void main() {
  test('fetch when response is valid should return rendezvous with date on local timezone', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (request.url.toString() != "BASE_URL/jeunes/userId/home") return invalidHttpResponse();
      return Response.bytes(loadTestAssetsAsBytes("home.json"), 200);
    });
    final repository = RendezvousRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final rendezvous = await repository.fetch("userId", Void);

    // Then
    expect(rendezvous, isNotNull);
    expect(rendezvous!.length, 4);
    expect(
      rendezvous.first,
      Rendezvous(
        id: "89092e0a-1111-411b-ac32-4e8cb18498e4",
        date: parseDateTimeUtcWithCurrentTimeZone("2021-11-28T13:34:00.000Z"),
        title: "Rendez-vous conseiller",
        subtitle: "avec Nils",
        comment: "Suivi des actions",
        duration: "0:30:00",
        modality: "Par téléphone",
      ),
    );
  });

  test('fetch when response is invalid should return null', () async {
    // Given
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = RendezvousRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final rendezvous = await repository.fetch("userID", Void);

    // Then
    expect(rendezvous, isNull);
  });
}
