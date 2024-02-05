import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/tracking/tracking_event_action.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';

import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  late MockTrackingEventRepository repository;

  setUp(() {
    repository = MockTrackingEventRepository();
    when(
      () => repository.sendEvent(
        userId: "id",
        event: EventType.MESSAGE_ENVOYE,
        loginMode: LoginMode.MILO,
        brand: Brand.cej,
      ),
    ).thenAnswer((_) async => true);
  });

  test("Tracking event action should call repository", () async {
    // Given
    final store = givenState().loggedInUser().store((f) => {f.trackingEventRepository = repository});
    when(
      () => repository.sendEvent(
        userId: "id",
        event: EventType.MESSAGE_ENVOYE,
        loginMode: LoginMode.MILO,
        brand: Brand.cej,
      ),
    ).thenAnswer((_) async => true);

    // When
    store.dispatch(TrackingEventAction(EventType.MESSAGE_ENVOYE));

    // Then
    verify(
      () => repository.sendEvent(
        userId: "id",
        event: EventType.MESSAGE_ENVOYE,
        loginMode: LoginMode.MILO,
        brand: Brand.cej,
      ),
    ).called(1);
  });

  test("Tracking event action should call repository with proper brand", () async {
    // Given
    final store = givenBrsaState().loggedInPoleEmploiUser().store((f) => {f.trackingEventRepository = repository});
    when(
      () => repository.sendEvent(
        userId: "id",
        event: EventType.MESSAGE_ENVOYE,
        loginMode: LoginMode.POLE_EMPLOI,
        brand: Brand.brsa,
      ),
    ).thenAnswer((_) async => true);

    // When
    store.dispatch(TrackingEventAction(EventType.MESSAGE_ENVOYE));

    // Then
    verify(
      () => repository.sendEvent(
        userId: "id",
        event: EventType.MESSAGE_ENVOYE,
        loginMode: LoginMode.POLE_EMPLOI,
        brand: Brand.brsa,
      ),
    ).called(1);
  });

  test("Tracking event action not should call repository on demo mode", () async {
    // Given
    final store = givenState().loggedInUser().withDemoMode().store((f) => {f.trackingEventRepository = repository});

    // When
    store.dispatch(TrackingEventAction(EventType.MESSAGE_ENVOYE));

    // Then
    verifyNever(
      () => repository.sendEvent(
        userId: "id",
        event: EventType.MESSAGE_ENVOYE,
        loginMode: LoginMode.MILO,
        brand: Brand.cej,
      ),
    );
  });
}
