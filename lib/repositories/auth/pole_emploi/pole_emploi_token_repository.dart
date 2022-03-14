import 'package:pass_emploi_app/auth/auth_token_response.dart';

class PoleEmploiTokenRepository {
  AuthTokenResponse? _authTokenResponse;

  void setPoleEmploiAuthToken(AuthTokenResponse authTokenResponse) => _authTokenResponse = authTokenResponse;

  String? getPoleEmploiAccessToken() => _authTokenResponse?.accessToken;

  void clearPoleEmploiAuthToken() => _authTokenResponse = null;
}
