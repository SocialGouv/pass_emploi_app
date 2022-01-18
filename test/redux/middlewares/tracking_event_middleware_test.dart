import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/redux/actions/tracking_event_action.dart';
import 'package:pass_emploi_app/redux/middlewares/tracking_event_middleware.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:pass_emploi_app/repositories/tracking_analytics/tracking_event_repository.dart';
import 'package:redux/redux.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';

main() {
  final repository = TrackingEventRepositoryMock();
  final middleware = TrackingEventMiddleware(repository);

  test('call should call tracking event repository', () async {
    // Given
    final storeSpy = StoreSpy();
    final trackingEventAction = RequestTrackingEventAction(EventType.MESSAGE_ENVOYE);
    final store = Store<AppState>(
      storeSpy.reducer,
      initialState: AppState.initialState().copyWith(loginState: successMiloUserState()),
    );

    // When
    await middleware.call(store, trackingEventAction, (action) => {});

    // Then
    expect(repository.wasCalled, true);
  });
}

class StoreSpy {

  AppState reducer(AppState currentState, dynamic action) {
    return currentState;
  }
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
