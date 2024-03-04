import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_token_repository.dart';

import '../../dsl/sut_dio_repository.dart';

void main() {
  group('CvmTokenRepository', () {
    final sut = DioRepositorySut<CvmTokenRepository>();
    sut.givenRepository((client) => CvmTokenRepository(client));

    group('getToken', () {
      sut.when((repository) => repository.getToken("UID"));

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "accueil_mission_locale.json");
        sut.givenRawResponse(data: "token-cvm");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/jeunes/UID/pole-emploi/idp-token",
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<String?>((result) {
            expect(result, "token-cvm");
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
