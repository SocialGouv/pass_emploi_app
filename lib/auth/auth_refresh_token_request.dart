class AuthRefreshTokenRequest {
  final String clientId;
  final String loginRedirectUrl;
  final String issuer;
  final String refreshToken;
  final String clientSecret;

  AuthRefreshTokenRequest(this.clientId, this.loginRedirectUrl, this.issuer, this.refreshToken, this.clientSecret);
}
