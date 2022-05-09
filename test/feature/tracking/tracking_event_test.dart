import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/tracking/tracking_event_action.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
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

  test("Tracking event action not should call repository when demo", () async {
    // Given
    final factory = TestStoreFactory();
    final repository = TrackingEventRepositoryMock();
    factory.trackingEventRepository = repository;
    final initialState = AppState.initialState().copyWith(
        loginState: LoginSuccessState(User(
      id: "id",
      firstName: "F",
      lastName: "L",
      email: "first.last@pole-emploi.fr",
      loginMode: LoginMode.DEMO_MILO,
    )));
    final store = factory.initializeReduxStore(initialState: initialState);

    // When
    store.dispatch(TrackingEventAction(EventType.MESSAGE_ENVOYE));

    // Then
    expect(repository.wasCalled, false);
  });
}

class TrackingEventRepositoryMock extends TrackingEventRepository {
  bool wasCalled = false;

  TrackingEventRepositoryMock() : super("", DummyHttpClient());

  @override
  Future<bool> sendEvent({required String userId, required EventType event, required LoginMode loginMode}) async {
    wasCalled = true;
    return userId == "error" ? false : true;
  }
}
