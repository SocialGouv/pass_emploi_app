import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/network/post_evenement_engagement.dart';
import 'package:pass_emploi_app/repositories/evenement_engagement/evenement_engagement_repository.dart';

import '../../dsl/sut_dio_repository.dart';

void main() {
  final sut = DioRepositorySut<EvenementEngagementRepository>();
  sut.givenRepository((client) => EvenementEngagementRepository(client));

  group("send", () {
    group('For CEJ brand', () {
      sut.when(
        (repository) => repository.send(
          userId: "userId",
          event: EvenementEngagement.MESSAGE_ENVOYE,
          loginMode: LoginMode.MILO,
          brand: Brand.cej,
        ),
      );

      group('when response is valid', () {
        sut.givenResponseCode(201);

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.post,
            url: "/evenements",
            jsonBody: {
              'type': 'MESSAGE_ENVOYE',
              'emetteur': {'type': 'JEUNE', 'structure': 'MILO', 'id': 'userId'}
            },
          );
        });

        test('response should be valid', () async {
          await sut.expectTrueAsResult();
        });
      });

      group('when response is invalid', () {
        sut.givenResponseCode(500);

        test('response should be null', () async {
          await sut.expectFalseAsResult();
        });
      });
    });

    group('For pass emploi brand', () {
      sut.when(
        (repository) => repository.send(
          userId: "userId",
          event: EvenementEngagement.MESSAGE_ENVOYE,
          loginMode: LoginMode.POLE_EMPLOI,
          brand: Brand.passEmploi,
        ),
      );

      group('when response is valid', () {
        sut.givenResponseCode(201);

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.post,
            url: "/evenements",
            jsonBody: {
              'type': 'MESSAGE_ENVOYE',
              'emetteur': {'type': 'JEUNE', 'structure': 'POLE_EMPLOI_BRSA', 'id': 'userId'}
            },
          );
        });

        test('response should be valid', () async {
          await sut.expectTrueAsResult();
        });
      });

      group('when response is invalid', () {
        sut.givenResponseCode(500);

        test('response should be null', () async {
          await sut.expectFalseAsResult();
        });
      });
    });
  });
}
