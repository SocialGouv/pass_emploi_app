import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/repositories/tracking_analytics/tracking_event_repository.dart';

import '../doubles/fixtures.dart';
import '../doubles/stubs.dart';

void main() {
  test('sendEvent should successfully send event when response is valid', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "POST") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/evenements")) return invalidHttpResponse();
      return Response("", 201);
    });
    final repository = TrackingEventRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final isEventSentWithSuccess = await repository.sendEvent(
      userId: "userId",
      event: EventType.MESSAGE_ENVOYE,
      structure: LoginStructure.MILO,
    );

    // Then
    expect(isEventSentWithSuccess, true);
  });

  test('sendEvent should return false when response in invalid', () async {
    // Given
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = TrackingEventRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final isEventSentWithSuccess = await repository.sendEvent(
      userId: "userId",
      event: EventType.MESSAGE_ENVOYE,
      structure: LoginStructure.MILO,
    );

    // Then
    expect(isEventSentWithSuccess, false);
  });

  test('sendEvent should return false when response throws exception', () async {
    // Given
    final httpClient = MockClient((request) async => throw Exception());
    final repository = TrackingEventRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final isEventSentWithSuccess = await repository.sendEvent(
      userId: "userId",
      event: EventType.MESSAGE_ENVOYE,
      structure: LoginStructure.MILO,
    );

    // Then
    expect(isEventSentWithSuccess, false);
  });
}
