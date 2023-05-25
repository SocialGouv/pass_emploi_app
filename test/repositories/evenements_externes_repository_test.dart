import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/evenements_externes/evenements_externes_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenements_externes/evenements_externes_filtres_recherche.dart';
import 'package:pass_emploi_app/models/evenement_externe.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/repositories/evenements_externes_repository.dart';

import '../doubles/fixtures.dart';
import '../dsl/sut_repository2.dart';

void main() {
  group('EvenementsExternesRepository', () {
    final sut = RepositorySut2<EvenementsExternesRepository>();
    sut.givenRepository((client) => EvenementsExternesRepository(client));

    group('rechercher', () {
      sut.when(
        (repository) => repository.rechercher(
          userId: 'UID',
          request: RechercheRequest(
            EvenementsExternesCriteresRecherche(location: mockCommuneLocation()),
            EvenementsExternesFiltresRecherche(),
            1,
          ),
        ),
      );

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: 'recherche_evenements_externes.json');

        test('request should be valid', () async {
          await sut.expectRequestBody(
              method: HttpMethod.get,
              url: '/evenements-emploi',
              queryParameters: {
                'codePostal': mockCommuneLocation().codePostal,
              });
        });

        test('response should be valid', () async {
          await sut.expectResult<RechercheResponse<EvenementExterne>?>((response) {
            expect(response, isNotNull);
            expect(response!.results, hasLength(1));
            expect(response.results.first, EvenementExterne(id: '1', titre: 'Atelier du travail'));
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
