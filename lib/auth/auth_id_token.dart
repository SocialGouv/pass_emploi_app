import 'dart:convert';

import 'package:equatable/equatable.dart';

const int _additionalExpirationSecuritySeconds = 15;

enum LoginMode {
  MILO("MILO"),
  POLE_EMPLOI("POLE_EMPLOI"),
  PASS_EMPLOI("PASS_EMPLOI"),
  DEMO_PE("DEMO_PE"),
  DEMO_MILO("DEMO_MILO");

  final String value;

  const LoginMode(this.value);

  static LoginMode fromString(String value) {
    return LoginMode.values.firstWhere((e) => e.value == value);
  }
}

extension LoginModeExtension on LoginMode? {
  bool isDemo() => this == LoginMode.DEMO_PE || this == LoginMode.DEMO_MILO;

  bool isPe() => this == LoginMode.DEMO_PE || this == LoginMode.POLE_EMPLOI;

  bool isMiLo() => this == LoginMode.DEMO_MILO || this == LoginMode.MILO || this == LoginMode.PASS_EMPLOI;
}

class AuthIdToken extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final String? email;
  final int issuedAt;
  final int expiresAt;
  final String loginMode;

  AuthIdToken({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.issuedAt,
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
      issuedAt: json["iat"] as int,
      expiresAt: json["exp"] as int,
      loginMode: json["userStructure"] as String,
    );
  }

  bool isValid({required DateTime now, int? maxLivingTimeInSeconds}) {
    return isValidBasedOnExpirationDate(now) && isValidBasedOnMaxLivingTime(now, maxLivingTimeInSeconds);
  }

  bool isValidBasedOnMaxLivingTime(DateTime now, int? maxLivingTimeInSeconds) {
    if (maxLivingTimeInSeconds == null) return true;
    return now.isStillValidWith(expirationDateInSeconds: issuedAt + maxLivingTimeInSeconds);
  }

  bool isValidBasedOnExpirationDate(DateTime now) => now.isStillValidWith(expirationDateInSeconds: expiresAt);

  @override
  List<Object?> get props => [userId, firstName, lastName, issuedAt, expiresAt];

  LoginMode getLoginMode() {
    if (loginMode == "MILO") return LoginMode.MILO;
    if (loginMode.contains("POLE_EMPLOI")) return LoginMode.POLE_EMPLOI;
    return LoginMode.PASS_EMPLOI;
  }
}

extension _DateTimeExtension on DateTime {
  bool isStillValidWith({required int expirationDateInSeconds}) {
    return (expirationDateInSeconds - _additionalExpirationSecuritySeconds) > millisecondsSinceEpoch / 1000;
  }
}
