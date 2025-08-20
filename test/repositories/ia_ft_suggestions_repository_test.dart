import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/demarche_ia_dto.dart';
import 'package:pass_emploi_app/repositories/ia_ft_suggestions_repository.dart';

import '../dsl/sut_dio_repository.dart';

void main() {
  group('IaFtSuggestionsRepository', () {
    final sut = DioRepositorySut<IaFtSuggestionsRepository>();
    sut.givenRepository((client) => IaFtSuggestionsRepository(client));

    group('get', () {
      sut.when((repository) => repository.get("userId", "query"));

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: 'ia_ft_suggestions.json');

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.post,
            url: "/jeunes/userId/demarches-ia",
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<List<DemarcheIaDto>?>((result) {
            expect(result, isNotEmpty);
            expect(result!.first.codeQuoi, "P01");
            expect(result.first.codePourquoi, "P8");
            expect(result.first.description, "description");
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
