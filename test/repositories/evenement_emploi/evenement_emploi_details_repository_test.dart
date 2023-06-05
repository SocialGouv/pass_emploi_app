import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi_details.dart';
import 'package:pass_emploi_app/repositories/evenement_emploi/evenement_emploi_details_repository.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/sut_repository2.dart';

void main() {
  group('EvenementEmploiDetailsRepository', () {
    final sut = RepositorySut2<EvenementEmploiDetailsRepository>();
    sut.givenRepository((client) => EvenementEmploiDetailsRepository(client));

    group('get', () {
      sut.when((repository) => repository.get("IDEVENT"));

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "evenement_emploi_details.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/evenements-emploi/IDEVENT",
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<EvenementEmploiDetails?>((event) {
            expect(event, isNotNull);
            expect(event, mockEvenementEmploiDetails());
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
