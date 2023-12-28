import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi_modalite.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi_type.dart';
import 'package:pass_emploi_app/models/evenement_emploi/secteur_activite.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/repositories/evenement_emploi/evenement_emploi_repository.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/sut_dio_repository.dart';
import '../../utils/test_datetime.dart';

void main() {
  group('EvenementEmploiRepository', () {
    final sut = DioRepositorySut<EvenementEmploiRepository>();
    final secteurActiviteQueryMapper = MockSecteurActiviteQueryMapper();
    final typeQueryMapper = MockEvenementEmploiTypeQueryMapper();
    sut.givenRepository((client) => EvenementEmploiRepository(client, secteurActiviteQueryMapper, typeQueryMapper));

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
            EvenementEmploiFiltresRecherche.noFiltre(),
            1,
          ),
        ),
      );

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: 'recherche_evenements_emploi.json');

        test('request should be valid', () {
          sut.expectRequestBody(method: HttpMethod.get, url: '/evenements-emploi', queryParameters: {
            'codePostal': mockCommuneLocation().codePostal,
            'secteurActivite': 'A',
            'page': '1',
            'limit': '20',
          });
        });

        test('response should be valid', () {
          sut.expectResult<RechercheResponse<EvenementEmploi>?>((response) {
            expect(response?.canLoadMore, false);
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
                dateDebut: parseDateTimeUnconsideringTimeZone('2023-05-17T10:00:00.000+00:00'),
                dateFin: parseDateTimeUnconsideringTimeZone('2023-05-17T12:00:00.000+00:00'),
                modalites: [EvenementEmploiModalite.enPhysique, EvenementEmploiModalite.aDistance],
              ),
            );
          });
        });
      });

      group('when response is invalid', () {
        sut.givenResponseCode(500);

        test('response should be null', () {
          sut.expectNullResult();
        });
      });
    });

    group('rechercher when filtres are applied', () {
      sut.givenJsonResponse(fromJson: 'recherche_evenements_emploi.json');

      group('modalités…', () {
        group('when absent', () {
          sut.when(
            (repository) => repository.rechercher(
              userId: 'UID',
              request: RechercheRequest(
                EvenementEmploiCriteresRecherche(location: mockCommuneLocation(), secteurActivite: null),
                EvenementEmploiFiltresRecherche.withFiltres(modalites: []),
                1,
              ),
            ),
          );

          test('query parameters should be properly built without modalite', () {
            sut.expectRequestBody(method: HttpMethod.get, url: '/evenements-emploi', queryParameters: {
              'codePostal': mockCommuneLocation().codePostal,
              'page': '1',
              'limit': '20',
            });
          });
        });

        group('when both modalité are selected', () {
          sut.when(
            (repository) => repository.rechercher(
              userId: 'UID',
              request: RechercheRequest(
                EvenementEmploiCriteresRecherche(location: mockCommuneLocation(), secteurActivite: null),
                EvenementEmploiFiltresRecherche.withFiltres(
                  modalites: [EvenementEmploiModalite.enPhysique, EvenementEmploiModalite.aDistance],
                ),
                1,
              ),
            ),
          );

          test('query parameters should be properly built without modalite', () {
            sut.expectRequestBody(method: HttpMethod.get, url: '/evenements-emploi', queryParameters: {
              'codePostal': mockCommuneLocation().codePostal,
              'page': '1',
              'limit': '20',
            });
          });
        });

        group('when "en physique" is selected', () {
          sut.when(
            (repository) => repository.rechercher(
              userId: 'UID',
              request: RechercheRequest(
                EvenementEmploiCriteresRecherche(location: mockCommuneLocation(), secteurActivite: null),
                EvenementEmploiFiltresRecherche.withFiltres(
                  modalites: [EvenementEmploiModalite.enPhysique],
                ),
                1,
              ),
            ),
          );

          test('query parameters should be properly built without modalite', () {
            sut.expectRequestBody(method: HttpMethod.get, url: '/evenements-emploi', queryParameters: {
              'codePostal': mockCommuneLocation().codePostal,
              'modalite': 'ENPHY',
              'page': '1',
              'limit': '20',
            });
          });
        });

        group('when "à distance" is selected', () {
          sut.when(
            (repository) => repository.rechercher(
              userId: 'UID',
              request: RechercheRequest(
                EvenementEmploiCriteresRecherche(location: mockCommuneLocation(), secteurActivite: null),
                EvenementEmploiFiltresRecherche.withFiltres(
                  modalites: [EvenementEmploiModalite.aDistance],
                ),
                1,
              ),
            ),
          );

          test('query parameters should be properly built without modalite', () {
            sut.expectRequestBody(method: HttpMethod.get, url: '/evenements-emploi', queryParameters: {
              'codePostal': mockCommuneLocation().codePostal,
              'modalite': 'ADIST',
              'page': '1',
              'limit': '20',
            });
          });
        });
      });

      group('date de début…', () {
        sut.when(
          (repository) => repository.rechercher(
            userId: 'UID',
            request: RechercheRequest(
              EvenementEmploiCriteresRecherche(location: mockCommuneLocation(), secteurActivite: null),
              EvenementEmploiFiltresRecherche.withFiltres(
                dateDebut: DateTime(2023, 1, 30, 7),
              ),
              1,
            ),
          ),
        );

        test('query parameters should be properly built with date debut at start of day', () {
          sut.expectRequestBody(method: HttpMethod.get, url: '/evenements-emploi', queryParameters: {
            'codePostal': mockCommuneLocation().codePostal,
            'dateDebut': '2023-01-30T00:00:00.000',
            'page': '1',
            'limit': '20',
          });
        });
      });

      group('date de fin…', () {
        sut.when(
          (repository) => repository.rechercher(
            userId: 'UID',
            request: RechercheRequest(
              EvenementEmploiCriteresRecherche(location: mockCommuneLocation(), secteurActivite: null),
              EvenementEmploiFiltresRecherche.withFiltres(
                dateFin: DateTime(2023, 1, 30, 7),
              ),
              1,
            ),
          ),
        );

        test('query parameters should be properly built with date debut at end of day', () {
          sut.expectRequestBody(method: HttpMethod.get, url: '/evenements-emploi', queryParameters: {
            'codePostal': mockCommuneLocation().codePostal,
            'dateFin': '2023-01-30T23:59:59.999',
            'page': '1',
            'limit': '20',
          });
        });
      });

      group('type…', () {
        when(() => typeQueryMapper.getQueryParamValue(EvenementEmploiType.conference)).thenReturn('15');

        sut.when(
          (repository) => repository.rechercher(
            userId: 'UID',
            request: RechercheRequest(
              EvenementEmploiCriteresRecherche(location: mockCommuneLocation(), secteurActivite: null),
              EvenementEmploiFiltresRecherche.withFiltres(type: EvenementEmploiType.conference),
              1,
            ),
          ),
        );

        test('query parameters should be properly built without modalite', () {
          sut.expectRequestBody(method: HttpMethod.get, url: '/evenements-emploi', queryParameters: {
            'codePostal': mockCommuneLocation().codePostal,
            'typeEvenement': '15',
            'page': '1',
            'limit': '20',
          });
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

  group('EvenementEmploiTypeQueryMapper', () {
    void assertQueryParamValue(EvenementEmploiType type, String expected) {
      test('when $type then expect \'$expected\' query param value', () {
        // Given
        final mapper = EvenementEmploiTypeQueryMapper();

        // When
        final queryParamValue = mapper.getQueryParamValue(type);

        // Then
        expect(queryParamValue, expected);
      });
    }

    assertQueryParamValue(EvenementEmploiType.reunionInformation, '13');
    assertQueryParamValue(EvenementEmploiType.forum, '14');
    assertQueryParamValue(EvenementEmploiType.conference, '15');
    assertQueryParamValue(EvenementEmploiType.atelier, '16');
    assertQueryParamValue(EvenementEmploiType.salonEnLigne, '17');
    assertQueryParamValue(EvenementEmploiType.jobDating, '18');
    assertQueryParamValue(EvenementEmploiType.visiteEntreprise, '31');
    assertQueryParamValue(EvenementEmploiType.portesOuvertes, '32');
  });
}
