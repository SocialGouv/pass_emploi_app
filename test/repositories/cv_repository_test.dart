import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/cv_pole_emploi.dart';
import 'package:pass_emploi_app/repositories/cv_repository.dart';

import '../doubles/fixtures.dart';
import '../dsl/sut_repository2.dart';

void main() {
  group('CvRepository', () {
    final sut = RepositorySut2<CvRepository>();
    sut.givenRepository((client) => CvRepository(client));

    group('getCvs', () {
      sut.when((repository) => repository.getCvs("id-jeune"));

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "cv_pole_emploi.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/jeunes/id-jeune/pole-emploi/cv",
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<List<CvPoleEmploi>?>((cvList) {
            expect(cvList, mockCvPoleEmploiList());
          });
        });
      });
    });

    group('when response is invalid', () {
      sut.givenResponseCode(500);

      // TODO: FIRST not complient
      test('response should be null', () async {
        await sut.expectNullResult();
      });
    });
  });
}
