import 'package:equatable/equatable.dart';

class AuthTokenRequest extends Equatable {
  final String clientId;
  final String loginRedirectUrl;
  final String issuer;
  final List<String> scopes;
  final String clientSecret;

  AuthTokenRequest(this.clientId, this.loginRedirectUrl, this.issuer, this.scopes, this.clientSecret);

  @override
  List<Object?> get props => [clientId, loginRedirectUrl, issuer, scopes, clientSecret];
}
