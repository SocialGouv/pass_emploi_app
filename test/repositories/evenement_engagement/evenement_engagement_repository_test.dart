import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/network/post_evenement_engagement.dart';
import 'package:pass_emploi_app/repositories/evenement_engagement/evenement_engagement_repository.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/sut_dio_repository.dart';

void main() {
  final sut = DioRepositorySut<EvenementEngagementRepository>();
  sut.givenRepository((client) => EvenementEngagementRepository(client));

  group("send", () {
    group('For Milo user in CEJ accompagnement', () {
      sut.when(
        (repository) => repository.send(
          user: mockUser(id: 'userId', loginMode: LoginMode.MILO, accompagnement: Accompagnement.cej),
          event: EvenementEngagement.MESSAGE_ENVOYE,
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

    group('For Pôle emploi user in CEJ accompagnement', () {
      sut.when(
        (repository) => repository.send(
          user: mockUser(id: 'userId', loginMode: LoginMode.POLE_EMPLOI, accompagnement: Accompagnement.cej),
          event: EvenementEngagement.MESSAGE_ENVOYE,
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
              'emetteur': {'type': 'JEUNE', 'structure': 'POLE_EMPLOI', 'id': 'userId'}
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

    group('For Pôle emploi user in RSA accompagnement', () {
      sut.when(
        (repository) => repository.send(
          user:
              mockUser(id: 'userId', loginMode: LoginMode.POLE_EMPLOI, accompagnement: Accompagnement.rsaFranceTravail),
          event: EvenementEngagement.MESSAGE_ENVOYE,
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

    group('For Pôle emploi user in AIJ accompagnement', () {
      sut.when(
        (repository) => repository.send(
          user: mockUser(id: 'userId', loginMode: LoginMode.POLE_EMPLOI, accompagnement: Accompagnement.aij),
          event: EvenementEngagement.MESSAGE_ENVOYE,
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
              'emetteur': {'type': 'JEUNE', 'structure': 'POLE_EMPLOI_AIJ', 'id': 'userId'}
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
