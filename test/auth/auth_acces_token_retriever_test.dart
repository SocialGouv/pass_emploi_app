import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_access_token_retriever.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';

import '../doubles/dummies.dart';
import '../doubles/fixtures.dart';
import '../doubles/spies.dart';

void main() {
  test("Exception ia thrown when id token is null", () async {
    // Given
    final tokenRetriever = AuthAccessTokenRetriever(AuthenticatorNotLoggedInStub());
    // When-Then
    expect(() async => await tokenRetriever.accessToken(), throwsException);
  });

  test("Access token is returned when id token is valid", () async {
    // Given
    final tokenRetriever = AuthAccessTokenRetriever(AuthenticatorLoggedInStub());
    // When-Then
    expect(await tokenRetriever.accessToken(), "Access token");
  });
}

class AuthenticatorNotLoggedInStub extends Authenticator {
  AuthenticatorNotLoggedInStub() : super(DummyAuthWrapper(), configuration(), SharedPreferencesSpy());

  @override
  AuthIdToken? idToken() => null;
}

class AuthenticatorLoggedInStub extends Authenticator {
  AuthenticatorLoggedInStub() : super(DummyAuthWrapper(), configuration(), SharedPreferencesSpy());

  @override
  AuthIdToken? idToken() => AuthIdToken(
        userId: "id",
        firstName: "F",
        lastName: "L",
        expiresAt: (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 1000,
      );

  @override
  String? accessToken() => "Access token";
}
