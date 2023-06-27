import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/repositories/service_civique/service_civique_repository.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/sut_dio_repository.dart';

void main() {
  group('ServiceCiviqueRepository', () {
    final sut = DioRepositorySut<ServiceCiviqueRepository>();
    sut.givenRepository((client) => ServiceCiviqueRepository(client));

    group('postSavedSearch', () {
      sut.when(
        (repository) => repository.rechercher(
          userId: "userId",
          request: mockRechercheServiceCiviqueRequestWithFiltres(),
        ),
      );
      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "service_civique_offres.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url:
                "/services-civique?page=1&limit=50&distance=500&dateDeDebutMinimum=2023-01-01T00%3A00%3A00.000&domaine=all",
          );
        });

        test('response should be true', () async {
          await sut.expectResult<RechercheResponse<ServiceCivique>?>((response) {
            expect(response, isNotNull);
            expect(response!.canLoadMore, isFalse);
            expect(response.results, mockOffresServiceCiviqueAccompagnementInsertion());
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
