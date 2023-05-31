import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/models/evenement_emploi.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/models/secteur_activite.dart';
import 'package:pass_emploi_app/repositories/evenement_emploi_repository.dart';

import '../doubles/fixtures.dart';
import '../doubles/mocks.dart';
import '../dsl/sut_repository2.dart';
import '../utils/test_datetime.dart';

void main() {
  group('EvenementEmploiRepository', () {
    final sut = RepositorySut2<EvenementEmploiRepository>();
    final secteurActiviteQueryMapper = MockSecteurActiviteQueryMapper();
    sut.givenRepository((client) => EvenementEmploiRepository(client, secteurActiviteQueryMapper));

    group('rechercher', () {
      when(() => secteurActiviteQueryMapper.getQueryParamValue(SecteurActivite.agriculture)).thenReturn('A');

      sut.when(
        (repository) => repository.rechercher(
          userId: 'UID',
          request: RechercheRequest(
            EvenementEmploiCriteresRecherche(
              location: mockCommuneLocation(),
              secteurActivite: SecteurActivite.agriculture,
            ),
            EvenementEmploiFiltresRecherche(),
            1,
          ),
        ),
      );

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: 'recherche_evenements_emploi.json');

        test('request should be valid', () async {
          await sut.expectRequestBody(method: HttpMethod.get, url: '/evenements-emploi', queryParameters: {
            'codePostal': mockCommuneLocation().codePostal,
            'secteurActivite': 'A',
          });
        });

        test('response should be valid', () async {
          await sut.expectResult<RechercheResponse<EvenementEmploi>?>((response) {
            expect(response, isNotNull);
            expect(response!.results, hasLength(1));
            expect(
              response.results.first,
              EvenementEmploi(
                id: '1',
                titre: 'Atelier du travail',
                type: 'Atelier',
                ville: 'Marseille',
                codePostal: '13006',
                dateDebut: parseDateTimeUtcWithCurrentTimeZone('2023-05-17T10:00:00.000+00:00'),
                dateFin: parseDateTimeUtcWithCurrentTimeZone('2023-05-17T12:00:00.000+00:00'),
                modalites: [EvenementEmploiModalite.enPhysique, EvenementEmploiModalite.aDistance],
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
  });

  group('SecteurActiviteQueryMapper', () {
    void assertQueryParamValue(SecteurActivite secteurActivite, String expected) {
      test('when $secteurActivite then expect \'$expected\' query param value', () {
        // Given
        final mapper = SecteurActiviteQueryMapper();

        // When
        final queryParamValue = mapper.getQueryParamValue(secteurActivite);

        // Then
        expect(queryParamValue, expected);
      });
    }

    assertQueryParamValue(SecteurActivite.agriculture, 'A');
    assertQueryParamValue(SecteurActivite.art, 'B');
    assertQueryParamValue(SecteurActivite.banque, 'C');
    assertQueryParamValue(SecteurActivite.commerce, 'D');
    assertQueryParamValue(SecteurActivite.communication, 'E');
    assertQueryParamValue(SecteurActivite.batiment, 'F');
    assertQueryParamValue(SecteurActivite.tourisme, 'G');
    assertQueryParamValue(SecteurActivite.industrie, 'H');
    assertQueryParamValue(SecteurActivite.installation, 'I');
    assertQueryParamValue(SecteurActivite.sante, 'J');
    assertQueryParamValue(SecteurActivite.services, 'K');
    assertQueryParamValue(SecteurActivite.spectacle, 'L');
    assertQueryParamValue(SecteurActivite.support, 'M');
    assertQueryParamValue(SecteurActivite.transport, 'N');
  });
}
