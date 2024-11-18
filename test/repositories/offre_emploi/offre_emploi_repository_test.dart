import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/repositories/offre_emploi/offre_emploi_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../dsl/sut_dio_repository.dart';

void main() {
  final sut = DioRepositorySut<OffreEmploiRepository>();
  sut.givenRepository((client) => OffreEmploiRepository(client));

  group('rechercher', () {
    group('when request is with keyword and a department location', () {
      sut.when(
        (repository) => repository.rechercher(
          userId: 'ID',
          request: RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche>(
            EmploiCriteresRecherche(
              keyword: 'keyword',
              location: Location(libelle: 'Paris', code: '75', type: LocationType.DEPARTMENT),
              rechercheType: RechercheType.offreEmploiAndAlternance,
            ),
            EmploiFiltresRecherche.noFiltre(),
            1,
          ),
        ),
      );
      sut.givenJsonResponse(fromJson: "offres_emploi.json");

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: HttpMethod.get,
          url: '/offres-emploi',
          queryParameters: {
            'page': '1',
            'limit': '50',
            'q': 'keyword',
            'departement': '75',
          },
          options: Options(listFormat: ListFormat.multi),
        );
      });

      test('response should be valid', () async {
        await sut.expectResult<RechercheResponse<OffreEmploi>?>((result) {
          expect(result, isNotNull);
          expect(result!.canLoadMore, isFalse);
          expect(result.results.length, 4);
          final offreWithLocation = result.results.first;
          expect(
            offreWithLocation,
            OffreEmploi(
              id: "123YYCD",
              title: "Serveur / Serveuse de restaurant - chef de rang h/f   (H/F)",
              companyName: "BRASSERIE FLO",
              contractType: "CDI",
              isAlternance: false,
              location: "75 - PARIS 10",
              duration: "Temps plein",
              origin: null,
            ),
          );
          final offreWithoutLocation = result.results[3];
          expect(
            offreWithoutLocation,
            OffreEmploi(
              id: "123ZZZN1",
              duration: "Temps plein",
              location: null,
              contractType: "CDI",
              companyName: "SUPER TAXI",
              title: "Chauffeur / Chauffeuse de taxi (H/F)",
              isAlternance: false,
              origin: null,
            ),
          );
        });
      });
    });

    group('when request is with keyword and a commune location', () {
      sut.when(
        (repository) => repository.rechercher(
          userId: 'ID',
          request: RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche>(
            EmploiCriteresRecherche(
              keyword: 'keyword',
              location: Location(libelle: "Marseille", code: "13202", codePostal: "13002", type: LocationType.COMMUNE),
              rechercheType: RechercheType.offreEmploiAndAlternance,
            ),
            EmploiFiltresRecherche.noFiltre(),
            1,
          ),
        ),
      );

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: HttpMethod.get,
          url: '/offres-emploi',
          queryParameters: {
            'page': '1',
            'limit': '50',
            'q': 'keyword',
            'commune': '13202',
          },
        );
      });
    });

    group('when response is without keyword nor location ', () {
      sut.when(
        (repository) => repository.rechercher(
          userId: 'ID',
          request: RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche>(
            EmploiCriteresRecherche(
              keyword: '',
              location: null,
              rechercheType: RechercheType.offreEmploiAndAlternance,
            ),
            EmploiFiltresRecherche.noFiltre(),
            1,
          ),
        ),
      );

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: HttpMethod.get,
          url: '/offres-emploi',
          queryParameters: {
            'page': '1',
            'limit': '50',
          },
          options: Options(listFormat: ListFormat.multi),
        );
      });
    });

    group('when response is invalid', () {
      sut.givenResponseCode(HttpStatus.internalServerError);

      test('response should be null', () async => await sut.expectNullResult());
    });
  });

  group("when RechercheType…", () {
    group('is offreEmploiAndAlternance', () {
      sut.when(
        (repository) => repository.rechercher(
          userId: 'ID',
          request: RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche>(
            EmploiCriteresRecherche(
              keyword: '',
              location: null,
              rechercheType: RechercheType.offreEmploiAndAlternance,
            ),
            EmploiFiltresRecherche.noFiltre(),
            1,
          ),
        ),
      );

      test('should not set alternance query param', () async {
        await sut.expectRequestBody(
          method: HttpMethod.get,
          url: '/offres-emploi',
          queryParameters: {
            'page': '1',
            'limit': '50',
          },
        );
      });
    });

    group('is onlyAlternance', () {
      sut.when(
        (repository) => repository.rechercher(
          userId: 'ID',
          request: RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche>(
            EmploiCriteresRecherche(
              keyword: '',
              location: null,
              rechercheType: RechercheType.onlyAlternance,
            ),
            EmploiFiltresRecherche.noFiltre(),
            1,
          ),
        ),
      );

      test('should set alternance query param to true', () async {
        await sut.expectRequestBody(
          method: HttpMethod.get,
          url: '/offres-emploi',
          queryParameters: {
            'page': '1',
            'limit': '50',
            'alternance': 'true',
          },
          options: Options(listFormat: ListFormat.multi),
        );
      });
    });

    group('is onlyOffreEmploi', () {
      sut.when(
        (repository) => repository.rechercher(
          userId: 'ID',
          request: RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche>(
            EmploiCriteresRecherche(
              keyword: '',
              location: null,
              rechercheType: RechercheType.onlyOffreEmploi,
            ),
            EmploiFiltresRecherche.noFiltre(),
            1,
          ),
        ),
      );

      test('should set alternance query param to false', () async {
        await sut.expectRequestBody(
          method: HttpMethod.get,
          url: '/offres-emploi',
          queryParameters: {
            'page': '1',
            'limit': '50',
            'alternance': 'false',
          },
          options: Options(listFormat: ListFormat.multi),
        );
      });
    });
  });

  group("response when filtres are applied ...", () {
    void assertFiltres(String title, EmploiFiltresRecherche filtres, _ExpectedQueryParams expectedParams) {
      test(title, () async {
        // Given
        final dioMock = DioMock();
        final repository = OffreEmploiRepository(dioMock);

        // When
        final location = Location(libelle: "Issy", code: "03129", codePostal: "92130", type: LocationType.COMMUNE);
        await repository.rechercher(
          userId: "ID",
          request: RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche>(
            EmploiCriteresRecherche(
              keyword: "keyword",
              location: location,
              rechercheType: RechercheType.offreEmploiAndAlternance,
            ),
            filtres,
            1,
          ),
        );

        // Then
        final captured = verify(
          () => dioMock.get(
            '/offres-emploi',
            queryParameters: captureAny(named: 'queryParameters'),
            options: captureAny(named: 'options'),
          ),
        ).captured;
        expect((captured.last as Options).listFormat, ListFormat.multi);
        final queryParams = (captured.first as Map<String, dynamic>);
        return switch (expectedParams) {
          _Contains _ => expect(queryParams[expectedParams.key], expectedParams.value),
          _NotContains _ => expect(queryParams.containsKey(expectedParams.key), isFalse),
        };
      });
    }

    group(("when distance is applied should set proper rayon"), () {
      assertFiltres(
        "when distance is 70",
        EmploiFiltresRecherche.withFiltres(distance: 70),
        _Contains('rayon', '70'),
      );

      assertFiltres(
        "when distance is 32",
        EmploiFiltresRecherche.withFiltres(distance: 32),
        _Contains('rayon', '32'),
      );

      assertFiltres(
        "when not filter is set should not set rayon",
        EmploiFiltresRecherche.noFiltre(),
        _NotContains("rayon"),
      );
    });

    group(("when debutantAccepte is applied should set parameter"), () {
      assertFiltres(
        "when debutantAccepte is true",
        EmploiFiltresRecherche.withFiltres(debutantOnly: true),
        _Contains('debutantAccepte', 'true'),
      );

      assertFiltres(
        "when debutantAccepte is false",
        EmploiFiltresRecherche.withFiltres(debutantOnly: false),
        _Contains('debutantAccepte', 'false'),
      );

      assertFiltres(
        "when no filter is set should not set debutantAccepte",
        EmploiFiltresRecherche.noFiltre(),
        _NotContains("debutantAccepte"),
      );
    });

    group(
        ("MANDATORY FOR RETRO-COMPATIBILITY IN alertes : when experience filtre is applied should set proper values"),
        () {
      assertFiltres(
        "when experience is De 0 à 1 an",
        EmploiFiltresRecherche.withFiltres(experience: [ExperienceFiltre.de_zero_a_un_an]),
        _Contains('experience', ['1']),
      );

      assertFiltres(
        "when experience is De 1 an à 3 ans",
        EmploiFiltresRecherche.withFiltres(experience: [ExperienceFiltre.de_un_a_trois_ans]),
        _Contains('experience', ['2']),
      );

      assertFiltres(
        "when experience is 3 ans et +",
        EmploiFiltresRecherche.withFiltres(experience: [ExperienceFiltre.trois_ans_et_plus]),
        _Contains('experience', ['3']),
      );

      assertFiltres(
        "when experience is De 0 à 1 an and De 1 an à 3 ans",
        EmploiFiltresRecherche.withFiltres(experience: [
          ExperienceFiltre.de_zero_a_un_an,
          ExperienceFiltre.de_un_a_trois_ans,
        ]),
        _Contains('experience', ['1', '2']),
      );

      assertFiltres(
        "when all three experience values are selected",
        EmploiFiltresRecherche.withFiltres(experience: [
          ExperienceFiltre.de_zero_a_un_an,
          ExperienceFiltre.de_un_a_trois_ans,
          ExperienceFiltre.trois_ans_et_plus,
        ]),
        _Contains('experience', ['1', '2', '3']),
      );

      assertFiltres(
        "when no experience is selected",
        EmploiFiltresRecherche.withFiltres(experience: []),
        //(query) => !query.contains("experience"),
        _NotContains("experience"),
      );
      assertFiltres(
        "when no experience is selected - null",
        EmploiFiltresRecherche.noFiltre(),
        //(query) => !query.contains("experience"),
        _NotContains("experience"),
      );
    });

    group(("when contrat filtre is applied should set proper values"), () {
      assertFiltres(
        "when cdi is selected",
        EmploiFiltresRecherche.withFiltres(contrat: [ContratFiltre.cdi]),
        _Contains('contrat', ['CDI']),
      );

      assertFiltres(
        "when cdd is selected",
        EmploiFiltresRecherche.withFiltres(contrat: [ContratFiltre.cdd_interim_saisonnier]),
        _Contains('contrat', ['CDD-interim-saisonnier']),
      );

      assertFiltres(
        "when autre is selected",
        EmploiFiltresRecherche.withFiltres(contrat: [ContratFiltre.autre]),
        _Contains('contrat', ['autre']),
      );

      assertFiltres(
        "when cdi and autre are selected",
        EmploiFiltresRecherche.withFiltres(contrat: [ContratFiltre.cdi, ContratFiltre.autre]),
        _Contains('contrat', ['CDI', 'autre']),
      );

      assertFiltres(
        "when all three options are selected",
        EmploiFiltresRecherche.withFiltres(
          contrat: [ContratFiltre.cdi, ContratFiltre.cdd_interim_saisonnier, ContratFiltre.autre],
        ),
        _Contains('contrat', ['CDI', 'CDD-interim-saisonnier', 'autre']),
      );

      assertFiltres(
        "when no contrat is selected",
        EmploiFiltresRecherche.withFiltres(contrat: []),
        _NotContains("contrat"),
      );

      assertFiltres(
        "when no contrat is selected - null",
        EmploiFiltresRecherche.noFiltre(),
        _NotContains("contrat"),
      );
    });

    group("when duree filtre is applied should set proper values", () {
      assertFiltres(
        "when duree is temps plein",
        EmploiFiltresRecherche.withFiltres(duree: [DureeFiltre.temps_plein]),
        _Contains('duree', ['1']),
      );

      assertFiltres(
        "when duree is temps partiel",
        EmploiFiltresRecherche.withFiltres(duree: [DureeFiltre.temps_partiel]),
        _Contains('duree', ['2']),
      );

      assertFiltres(
        "when duree is both",
        EmploiFiltresRecherche.withFiltres(duree: [DureeFiltre.temps_plein, DureeFiltre.temps_partiel]),
        _Contains('duree', ['1', '2']),
      );

      assertFiltres(
        "when no duree is selected",
        EmploiFiltresRecherche.withFiltres(duree: []),
        _NotContains("duree"),
      );

      assertFiltres(
        "when no duree is selected - null",
        EmploiFiltresRecherche.noFiltre(),
        _NotContains("duree"),
      );
    });
  });
}

sealed class _ExpectedQueryParams {}

class _Contains extends _ExpectedQueryParams {
  final String key;
  final dynamic value;

  _Contains(this.key, this.value);
}

class _NotContains extends _ExpectedQueryParams {
  final String key;

  _NotContains(this.key);
}
