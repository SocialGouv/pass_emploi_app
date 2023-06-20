import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/repositories/tracking_analytics/tracking_event_repository.dart';

import '../../dsl/sut_repository2.dart';

void main() {
  final sut = RepositorySut2<TrackingEventRepository>();
  sut.givenRepository((client) => TrackingEventRepository(client));

  group("sendEvent", () {
    sut.when(
      (repository) => repository.sendEvent(
        userId: "userId",
        event: EventType.MESSAGE_ENVOYE,
        loginMode: LoginMode.MILO,
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
}
