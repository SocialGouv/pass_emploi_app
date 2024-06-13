import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_access_checker.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';

import '../doubles/spies.dart';

void main() {
  group("logoutUserIfTokenIsExpired should logout user depending on response message and status code", () {
    void assertLogout(String? message, int statusCode, {required bool expectLogout}) {
      test("Message $message with status code  $statusCode -> should ${expectLogout ? "logout" : "not logout"}",
          () async {
        // Given
        final store = StoreSpy();
        final authAccessChecker = AuthAccessChecker();
        authAccessChecker.setStore(store);

        // When
        authAccessChecker.logoutUserIfTokenIsExpired(message, statusCode);

        // Then
        if (expectLogout) {
          expect(store.dispatchedAction, isA<RequestLogoutAction>());
        } else {
          expect(store.dispatchedAction, isNull);
        }
      });
    }

    assertLogout(null, 200, expectLogout: false);
    assertLogout('message', 200, expectLogout: false);
    assertLogout('token_pole_emploi_expired', 200, expectLogout: true);
    assertLogout('message', 401, expectLogout: false);
    assertLogout('token_pole_emploi_expired', 401, expectLogout: true);
    assertLogout('token_milo_expired', 401, expectLogout: true);
    assertLogout('auth_user_not_found', 403, expectLogout: true);
    assertLogout(
      '{"statusCode":401,"message":"Unauthorized","code":"token_pole_emploi_expired"}',
      401,
      expectLogout: true,
    );
  });
}
