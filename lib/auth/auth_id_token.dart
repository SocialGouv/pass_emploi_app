import 'dart:convert';

import 'package:equatable/equatable.dart';

class AuthIdToken extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final int expiresAt;

  AuthIdToken({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.expiresAt,
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
      userId: json["sub"],
      firstName: json["given_name"],
      lastName: json["family_name"],
      expiresAt: json["exp"] as int,
    );
  }

  bool isValid() => expiresAt > DateTime.now().millisecondsSinceEpoch / 1000;

  int expiresInMillis() => expiresAt - DateTime.now().millisecondsSinceEpoch ~/ 1000;

  @override
  List<Object?> get props => [userId, firstName, lastName, expiresAt];
}
