import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/tracking/tracking_event_action.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/repositories/tracking_analytics/tracking_event_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

void main() {
  test("Tracking event action should call repository", () async {
    // Given
    final factory = TestStoreFactory();
    final repository = TrackingEventRepositoryMock();
    factory.trackingEventRepository = repository;
    final store = factory.initializeReduxStore(initialState: loggedInState());

    // When
    store.dispatch(TrackingEventAction(EventType.MESSAGE_ENVOYE));

    // Then
    expect(repository.wasCalled, true);
  });
}

class TrackingEventRepositoryMock extends TrackingEventRepository {
  bool wasCalled = false;

  TrackingEventRepositoryMock() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<bool> sendEvent({required String userId, required EventType event, required LoginMode loginMode}) async {
    wasCalled = true;
    return userId == "error" ? false : true;
  }
}
