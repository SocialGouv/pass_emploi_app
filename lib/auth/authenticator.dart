import 'package:pass_emploi_app/auth/auth_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';

import 'auth_wrapper.dart';

class Authenticator {
  final AuthWrapper authWrapper;
  final Configuration configuration;

  Authenticator(this.authWrapper, this.configuration);

  Future<AuthTokenResponse?> login() async {
    return authWrapper.login(
      AuthTokenRequest(
        configuration.authClientId,
        configuration.authLoginRedirectUrl,
        configuration.authIssuer,
        configuration.authScopes,
        configuration.authClientSecret,
      ),
    );
  }
}
