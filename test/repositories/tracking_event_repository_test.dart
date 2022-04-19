import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/repositories/tracking_analytics/tracking_event_repository.dart';

import '../doubles/fixtures.dart';

void main() {
  group("sendEvent when EventType ...", () {
    void assertMapping(EventType eventType, String expectedSerialization) {
      test("is $eventType should properly convert to $expectedSerialization", () async {
        final httpClient = MockClient((request) async {
          final requestJson = jsonUtf8Decode(request.bodyBytes);
          if (requestJson["type"] != expectedSerialization) {
            return invalidHttpResponse(message: "${requestJson["type"]} != $expectedSerialization");
          }
          return Response("", 201);
        });
        final repository = TrackingEventRepository("BASE_URL", httpClient);

        // When
        final isEventSentWithSuccess = await repository.sendEvent(
          userId: "userId",
          event: eventType,
          loginMode: LoginMode.MILO,
        );

        // Then
        expect(isEventSentWithSuccess, true);
      });
    }

    assertMapping(EventType.MESSAGE_ENVOYE, "MESSAGE_ENVOYE");
    assertMapping(EventType.OFFRE_EMPLOI_PARTAGEE, "OFFRE_EMPLOI_PARTAGEE");
    assertMapping(EventType.OFFRE_EMPLOI_POSTULEE, "OFFRE_EMPLOI_POSTULEE");
    assertMapping(EventType.OFFRE_ALTERNANCE_POSTULEE, "OFFRE_ALTERNANCE_POSTULEE");
    assertMapping(EventType.OFFRE_ALTERNANCE_PARTAGEE, "OFFRE_ALTERNANCE_PARTAGEE");
    assertMapping(EventType.OFFRE_IMMERSION_APPEL, "OFFRE_IMMERSION_APPEL");
    assertMapping(EventType.OFFRE_IMMERSION_ENVOI_EMAIL, "OFFRE_IMMERSION_ENVOI_EMAIL");
    assertMapping(EventType.OFFRE_IMMERSION_LOCALISATION, "OFFRE_IMMERSION_LOCALISATION");
    assertMapping(EventType.OFFRE_ALTERNANCE_AFFICHEE, "OFFRE_ALTERNANCE_AFFICHEE");
    assertMapping(EventType.OFFRE_EMPLOI_AFFICHEE, "OFFRE_EMPLOI_AFFICHEE");
  });

  test('sendEvent should successfully send event when response is valid', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "POST") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/evenements")) return invalidHttpResponse();
      return Response("", 201);
    });
    final repository = TrackingEventRepository("BASE_URL", httpClient);

    // When
    final isEventSentWithSuccess = await repository.sendEvent(
      userId: "userId",
      event: EventType.MESSAGE_ENVOYE,
      loginMode: LoginMode.MILO,
    );

    // Then
    expect(isEventSentWithSuccess, true);
  });

  test('sendEvent should return false when response in invalid', () async {
    // Given
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = TrackingEventRepository("BASE_URL", httpClient);

    // When
    final isEventSentWithSuccess = await repository.sendEvent(
      userId: "userId",
      event: EventType.MESSAGE_ENVOYE,
      loginMode: LoginMode.MILO,
    );

    // Then
    expect(isEventSentWithSuccess, false);
  });

  test('sendEvent should return false when response throws exception', () async {
    // Given
    final httpClient = MockClient((request) async => throw Exception());
    final repository = TrackingEventRepository("BASE_URL", httpClient);

    // When
    final isEventSentWithSuccess = await repository.sendEvent(
      userId: "userId",
      event: EventType.MESSAGE_ENVOYE,
      loginMode: LoginMode.MILO,
    );

    // Then
    expect(isEventSentWithSuccess, false);
  });
}
