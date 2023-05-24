import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/evenements_externes/evenements_externes_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenements_externes/evenements_externes_filtres_recherche.dart';
import 'package:pass_emploi_app/models/evenement_externe.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/repositories/evenements_externes_repository.dart';

import '../doubles/fixtures.dart';
import '../dsl/sut_repository2.dart';

void main() {
  group('EvenementsExternesRepository', () {
    final sut = RepositorySut2<EvenementsExternesRepository>();
    sut.givenRepository((client) => EvenementsExternesRepository(client));

    group('getAgendaMissionLocale', () {
      sut.when(
        (repository) => repository.rechercher(
          userId: "UID",
          request: RechercheRequest(
            EvenementsExternesCriteresRecherche(location: mockLocationParis()),
            EvenementsExternesFiltresRecherche(),
            1,
          ),
        ),
      );

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "recherche_evenements_externes.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
              method: HttpMethod.get,
              //TODO: url repository à voir avec le back
              url: "/todo",
              //TODO: queryParameters à voir avec le back pour location
              queryParameters: {
                'lat': mockLocationParis().latitude.toString(),
                'lon': mockLocationParis().longitude.toString(),
              });
        });

        test('response should be valid', () async {
          await sut.expectResult<List<EvenementExterne>?>((result) {
            expect(result, isNotNull);
            expect(result, mockEvenementsExternes());
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
