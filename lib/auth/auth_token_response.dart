import 'package:equatable/equatable.dart';

class AuthTokenResponse extends Equatable {
  final String idToken;
  final String accessToken;
  final String refreshToken;

  AuthTokenResponse({required this.idToken, required this.accessToken, required this.refreshToken});

  @override
  List<Object?> get props => [idToken, accessToken, refreshToken];
}
