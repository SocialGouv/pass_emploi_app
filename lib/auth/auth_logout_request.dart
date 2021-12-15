import 'package:equatable/equatable.dart';

class AuthLogoutRequest extends Equatable {
  final String idToken;
  final String logoutRedirectUrl;
  final String issuer;

  AuthLogoutRequest(this.idToken, this.logoutRedirectUrl, this.issuer);

  @override
  List<Object?> get props => [idToken, logoutRedirectUrl, issuer];
}
