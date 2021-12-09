import 'package:equatable/equatable.dart';

class AuthRefreshTokenRequest extends Equatable {
  final String clientId;
  final String loginRedirectUrl;
  final String issuer;
  final String refreshToken;
  final String clientSecret;

  AuthRefreshTokenRequest(this.clientId, this.loginRedirectUrl, this.issuer, this.refreshToken, this.clientSecret);

  @override
  List<Object?> get props => [clientId, loginRedirectUrl, issuer, refreshToken, clientSecret];
}
