import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/repositories/immersion_repository.dart';

import '../dsl/sut_repository2.dart';

void main() {
  group('ImmersionRepository', () {
    final sut = RepositorySut2<ImmersionRepository>();
    sut.givenRepository((client) => ImmersionRepository(client));

    group('search', () {
      sut.when((repository) => repository.search(userId: "ID", request: _requestWithoutFiltres()));

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "immersions.json");

        test('request should be valid', () {
          sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/offres-immersion",
            queryParameters: {'rome': 'J1301', 'lon': '7.7', 'lat': '48.7'},
          );
        });

        test('result should be valid', () {
          sut.expectResult<List<Immersion>?>((result) {
            expect(result, isNotNull);
            expect(result!.length, 13);
            expect(
              result.first,
              Immersion(
                id: "036383f3-85ca-4dbd-b636-ae2657164439",
                metier: "xxxx",
                nomEtablissement: "ACCUEIL DE JOUR POUR PERSONNES AGEES",
                secteurActivite: "xxxx",
                ville: "xxxx",
              ),
            );
          });
        });
      });

      group('when response is invalid', () {
        sut.givenResponseCode(500);

        test('result should be null', () {
          sut.expectNullResult();
        });
      });

      group('when response throws exception', () {
        sut.givenThrowingExceptionResponse();

        test('result should be null', () {
          sut.expectNullResult();
        });
      });
    });

    group('search when filtres are applied', () {
      sut.givenJsonResponse(fromJson: "immersions.json");

      group('when distance is 70', () {
        sut.when(
          (repository) => repository.search(
            userId: "ID",
            request: _requestWithFiltres(ImmersionSearchParametersFiltres.distance(70)),
          ),
        );
        test('query parameters should be properly built', () {
          sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/offres-immersion",
            queryParameters: {'rome': 'J1301', 'lon': '7.7', 'lat': '48.7', 'distance': '70'},
          );
        });
      });

      group('when no distance is set', () {
        sut.when(
          (repository) => repository.search(
            userId: "ID",
            request: _requestWithFiltres(ImmersionSearchParametersFiltres.noFiltres()),
          ),
        );
        test('query parameters should be properly built', () {
          sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/offres-immersion",
            queryParameters: {'rome': 'J1301', 'lon': '7.7', 'lat': '48.7'},
          );
        });
      });
    });
  });
}

SearchImmersionRequest _requestWithFiltres(ImmersionSearchParametersFiltres filtres) {
  return SearchImmersionRequest(
    codeRome: "J1301",
    location: Location(libelle: "Paris", code: "75", type: LocationType.COMMUNE, latitude: 48.7, longitude: 7.7),
    filtres: filtres,
  );
}

SearchImmersionRequest _requestWithoutFiltres() => _requestWithFiltres(ImmersionSearchParametersFiltres.noFiltres());
