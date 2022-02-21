import 'dart:convert';

import 'package:equatable/equatable.dart';

const int _additionalExpirationSecurityIsSeconds = 15;

enum LoginMode { MILO, POLE_EMPLOI, PASS_EMPLOI }

class AuthIdToken extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final String? email;
  final int expiresAt;
  final String loginMode;

  AuthIdToken({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.expiresAt,
    required this.loginMode,
  });

  factory AuthIdToken.parse(String idToken) {
    final parts = idToken.split(r'.');
    final Map<String, dynamic> json = jsonDecode(
      utf8.decode(
        base64Url.decode(
          base64Url.normalize(parts[1]),
        ),
      ),
    ) as Map<String, dynamic>;
    return AuthIdToken._fromJson(json);
  }

  factory AuthIdToken._fromJson(Map<String, dynamic> json) {
    return AuthIdToken(
      userId: json["userId"] as String,
      firstName: json["given_name"] as String,
      lastName: json["family_name"] as String,
      email: json["email"] as String?,
      expiresAt: json["exp"] as int,
      loginMode: json["userStructure"] as String,
    );
  }

  bool isValid() => (expiresAt - _additionalExpirationSecurityIsSeconds) > DateTime.now().millisecondsSinceEpoch / 1000;

  @override
  List<Object?> get props => [userId, firstName, lastName, expiresAt];

  LoginMode getLoginMode() {
    if (loginMode == "MILO") {
      return LoginMode.MILO;
    } else if (loginMode == "POLE_EMPLOI") {
      return LoginMode.POLE_EMPLOI;
    } else {
      return LoginMode.PASS_EMPLOI;
    }
  }
}
