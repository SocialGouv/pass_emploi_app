class AuthTokenResponse {
  final String idToken;
  final String accessToken;
  final String refreshToken;

  AuthTokenResponse({required this.idToken, required this.accessToken, required this.refreshToken});
}
