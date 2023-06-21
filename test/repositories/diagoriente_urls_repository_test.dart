import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/diagoriente_urls_repository.dart';

import '../doubles/fixtures.dart';
import '../dsl/sut_dio_repository.dart';

void main() {
  group('DiagorienteUrlsRepository', () {
    final sut = DioRepositorySut<DiagorienteUrlsRepository>();
    sut.givenRepository((client) => DiagorienteUrlsRepository(client));

    group('get', () {
      sut.when((repository) => repository.getUrls("userId"));

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "diagoriente_urls.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: '/jeunes/userId/diagoriente/urls',
          );
        });

        test('response should be valid', () async {
          await sut.expectResult((result) => expect(result, mockDiagorienteUrls()));
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
