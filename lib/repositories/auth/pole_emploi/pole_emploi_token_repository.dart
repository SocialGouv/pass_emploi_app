import 'package:pass_emploi_app/auth/auth_token_response.dart';

// TODO: temp solution to remove when token would be handled by backend
class PoleEmploiTokenRepository {
  AuthTokenResponse? _authTokenResponse;

  void setPoleEmploiAuthToken(AuthTokenResponse authTokenResponse) => _authTokenResponse = authTokenResponse;

  String? getPoleEmploiAccessToken() => _authTokenResponse?.accessToken;

  void clearPoleEmploiAuthToken() => _authTokenResponse = null;
}
