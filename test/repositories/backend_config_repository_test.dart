import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/backend_config_repository.dart';

import '../dsl/sut_dio_repository.dart';

void main() {
  group('CvRepository', () {
    final sut = DioRepositorySut<BackendConfigRepository>();
    sut.givenRepository((client) => BackendConfigRepository(client));

    group('getIdsConseillerCvmEarlyAdopters', () {
      sut.when((repository) => repository.getIdsConseillerCvmEarlyAdopters());
      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "config.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/config",
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<List<String>?>((conseillersIds) {
            expect(conseillersIds, ["id1", "id2"]);
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
