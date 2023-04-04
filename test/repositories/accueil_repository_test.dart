import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/accueil/accueil.dart';
import 'package:pass_emploi_app/repositories/accueil_repository.dart';

import '../doubles/fixtures.dart';
import '../dsl/sut_repository2.dart';

void main() {
  group('AccueilRepository', () {
    final sut = RepositorySut2<AccueilRepository>();
    sut.givenRepository((client) => AccueilRepository(client));

    group('getAccueilMissionLocale', () {
      sut.when((repository) => repository.getAccueilMissionLocale("UID", DateTime.utc(2022, 7, 7)));

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "accueil_mission_locale.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/jeunes/UID/milo/accueil?maintenant=2022-07-07T00%3A00%3A00%2B00%3A00",
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<Accueil?>((accueil) {
            expect(accueil, mockAccueilMilo());
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
    group('getAccueilPoleEmploi', () {
      sut.when((repository) => repository.getAccueilPoleEmploi("UID", DateTime.utc(2022, 7, 7)));

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "accueil_pole_emploi.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/jeunes/UID/pole-emploi/accueil?maintenant=2022-07-07T00%3A00%3A00%2B00%3A00",
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<Accueil?>((accueil) {
            expect(accueil, mockAccueilPoleEmploi());
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
