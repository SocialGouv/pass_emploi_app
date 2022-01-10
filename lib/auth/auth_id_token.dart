import 'dart:convert';

import 'package:equatable/equatable.dart';

const int _additionalExpirationSecurityIsSeconds = 15;

enum LoginStructure { MILO, POLE_EMPLOI, PASS_EMPLOI }

class AuthIdToken extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final int expiresAt;
  final String loginStructure;

  AuthIdToken({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.expiresAt,
    required this.loginStructure,
  });

  factory AuthIdToken.parse(String idToken) {
    final parts = idToken.split(r'.');
    final Map<String, dynamic> json = jsonDecode(
      utf8.decode(
        base64Url.decode(
          base64Url.normalize(parts[1]),
        ),
      ),
    );
    return AuthIdToken._fromJson(json);
  }

  factory AuthIdToken._fromJson(Map<String, dynamic> json) {
    return AuthIdToken(
      userId: json["userId"],
      firstName: json["given_name"],
      lastName: json["family_name"],
      expiresAt: json["exp"] as int,
      loginStructure: json["userStructure"],
    );
  }

  bool isValid() => (expiresAt - _additionalExpirationSecurityIsSeconds) > DateTime.now().millisecondsSinceEpoch / 1000;

  @override
  List<Object?> get props => [userId, firstName, lastName, expiresAt];

  LoginStructure getLoginMode() {
    if (loginStructure == "MILO") {
      return LoginStructure.MILO;
    } else if (loginStructure == "POLE_EMPLOI") {
      return LoginStructure.POLE_EMPLOI;
    } else {
      return LoginStructure.PASS_EMPLOI;
    }
  }
}
