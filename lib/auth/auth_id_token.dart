import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/login_mode.dart';

const int _additionalExpirationSecuritySeconds = 15;

class AuthIdToken extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final String? email;
  final int issuedAt;
  final int expiresAt;
  final String structure;

  AuthIdToken({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.issuedAt,
    required this.expiresAt,
    required this.structure,
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
      structure: json["userStructure"] as String,
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
    if (structure == 'MILO') return LoginMode.MILO;
    if (structure.contains('POLE_EMPLOI')) return LoginMode.POLE_EMPLOI;
    throw Exception('Unknown login mode');
  }

  Accompagnement getAccompagnement() {
    return switch (structure) {
      'POLE_EMPLOI_BRSA' => Accompagnement.rsaFranceTravail,
      'POLE_EMPLOI_AIJ' => Accompagnement.aij,
      _ => Accompagnement.cej,
    };
  }
}

extension _DateTimeExtension on DateTime {
  bool isStillValidWith({required int expirationDateInSeconds}) {
    return (expirationDateInSeconds - _additionalExpirationSecuritySeconds) > millisecondsSinceEpoch / 1000;
  }
}
