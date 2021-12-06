import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_access_token_retriever.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

import '../doubles/dummies.dart';
import '../doubles/fixtures.dart';
import '../doubles/spies.dart';

void main() {
  test("Throws an exception when id token is null", () async {
    // Given
    final tokenRetriever = AuthAccessTokenRetriever(AuthenticatorNotLoggedInStub());
    // When-Then
    expect(() async => await tokenRetriever.accessToken(), throwsException);
  });

  test("Returns access token when id token is valid", () async {
    // Given
    final tokenRetriever = AuthAccessTokenRetriever(AuthenticatorLoggedInAndValidIdTokenStub());
    // When-Then
    expect(await tokenRetriever.accessToken(), "Access token");
  });

  test("Returns access token when id token is invalid but refresh token is SUCCESSFUL", () async {
    // Given
    final authenticator = AuthenticatorLoggedInAndInvalidIdTokenStub(RefreshTokenStatus.SUCCESSFUL);
    final tokenRetriever = AuthAccessTokenRetriever(authenticator);

    // When-Then
    expect(await tokenRetriever.accessToken(), "Access token");
  });

  test("Throws an exception when id token is invalid and refresh token returns GENERIC_ERROR", () async {
    // Given
    final authenticator = AuthenticatorLoggedInAndInvalidIdTokenStub(RefreshTokenStatus.GENERIC_ERROR);
    final tokenRetriever = AuthAccessTokenRetriever(authenticator);

    // When-Then
    expect(() async => await tokenRetriever.accessToken(), throwsException);
  });

  test("Throws an exception when id token is invalid and refresh token returns USER_NOT_LOGGED_IN", () async {
    // Given
    final authenticator = AuthenticatorLoggedInAndInvalidIdTokenStub(RefreshTokenStatus.USER_NOT_LOGGED_IN);
    final tokenRetriever = AuthAccessTokenRetriever(authenticator);

    // When-Then
    expect(() async => await tokenRetriever.accessToken(), throwsException);
  });

  test("Throws an exception when id token is invalid and refresh token returns NETWORK_UNREACHABLE", () async {
    // Given
    final authenticator = AuthenticatorLoggedInAndInvalidIdTokenStub(RefreshTokenStatus.NETWORK_UNREACHABLE);
    final tokenRetriever = AuthAccessTokenRetriever(authenticator);

    // When-Then
    expect(() async => await tokenRetriever.accessToken(), throwsException);
  });

  test("Throws an exception when id token is invalid and refresh token returns EXPIRED_REFRESH_TOKEN", () async {
    // Given
    final store = SpyStore();
    final authenticator = AuthenticatorLoggedInAndInvalidIdTokenStub(RefreshTokenStatus.EXPIRED_REFRESH_TOKEN);
    final tokenRetriever = AuthAccessTokenRetriever(authenticator);
    tokenRetriever.setStore(store);

    // When-Then
    expect(() async => await tokenRetriever.accessToken(), throwsException);
  });

  test("Logout user when id token is invalid and refresh token returns EXPIRED_REFRESH_TOKEN", () async {
    // Given
    final store = SpyStore();
    final authenticator = AuthenticatorLoggedInAndInvalidIdTokenStub(RefreshTokenStatus.EXPIRED_REFRESH_TOKEN);
    final tokenRetriever = AuthAccessTokenRetriever(authenticator);
    tokenRetriever.setStore(store);

    // When
    try {
      await tokenRetriever.accessToken();
    } catch (e) {}

    // Then
    expect(store.dispatchedAction, isA<LogoutAction>());
  });
}

class AuthenticatorNotLoggedInStub extends Authenticator {
  AuthenticatorNotLoggedInStub() : super(DummyAuthWrapper(), configuration(), SharedPreferencesSpy());

  @override
  AuthIdToken? idToken() => null;
}

class AuthenticatorLoggedInAndValidIdTokenStub extends Authenticator {
  AuthenticatorLoggedInAndValidIdTokenStub() : super(DummyAuthWrapper(), configuration(), SharedPreferencesSpy());

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

class AuthenticatorLoggedInAndInvalidIdTokenStub extends Authenticator {
  final RefreshTokenStatus refreshTokenStatus;

  AuthenticatorLoggedInAndInvalidIdTokenStub(this.refreshTokenStatus)
      : super(DummyAuthWrapper(), configuration(), SharedPreferencesSpy());

  @override
  AuthIdToken? idToken() => AuthIdToken(userId: "id", firstName: "F", lastName: "L", expiresAt: 0);

  @override
  String? accessToken() => "Access token";

  @override
  Future<RefreshTokenStatus> refreshToken() => Future.value(refreshTokenStatus);
}

class SpyStore extends Store<AppState> {
  late Object dispatchedAction;

  SpyStore() : super(reducer, initialState: AppState.initialState());

  @override
  dispatch(action) {
    dispatchedAction = action;
  }
}
