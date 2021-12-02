import 'package:pass_emploi_app/auth/auth_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_wrapper.dart';

const String _idTokenKey = "idToken";
const String _accessTokenKey = "accessToken";
const String _refreshTokenKey = "refreshToken";

class Authenticator {
  final AuthWrapper authWrapper;
  final Configuration configuration;
  final SharedPreferences preferences;

  Authenticator(this.authWrapper, this.configuration, this.preferences);

  Future<AuthTokenResponse?> login() async {
    try {
      final response = await authWrapper.login(
        AuthTokenRequest(
          configuration.authClientId,
          configuration.authLoginRedirectUrl,
          configuration.authIssuer,
          configuration.authScopes,
          configuration.authClientSecret,
        ),
      );
      storeResponse(response);
      return response;
    } catch (e) {
      return null;
    }
  }

  void storeResponse(AuthTokenResponse response) {
    preferences.setString(_idTokenKey, response.idToken);
    preferences.setString(_accessTokenKey, response.accessToken);
    preferences.setString(_refreshTokenKey, response.refreshToken);
  }

  bool isLoggedIn() => preferences.containsKey(_idTokenKey);

}
