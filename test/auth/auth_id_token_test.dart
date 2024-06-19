import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';

void main() {
  final issuedAtTime = DateTime(2023);

  final expiredIn30Minutes = issuedAtTime.add(Duration(minutes: 30));
  final oneSecondBeforeExpiration = expiredIn30Minutes.subtract(Duration(seconds: 16));
  final oneSecondAfterExpiration = expiredIn30Minutes.subtract(Duration(seconds: 14));

  const maxLivingTime5Minutes = 5 * 60;
  final maxLivingTime = issuedAtTime.add(Duration(minutes: 5));
  final oneSecondBeforeMaxLivingTime = maxLivingTime.subtract(Duration(seconds: 16));
  final oneSecondAfterMaxLivingTime = maxLivingTime.subtract(Duration(seconds: 14));

  void assertIsValid({
    required DateTime now,
    int? maxLivingTimeInSeconds,
    required bool expected,
  }) {
    final token = AuthIdToken(
      userId: "",
      lastName: "",
      firstName: "",
      email: "",
      issuedAt: issuedAtTime.millisecondsSinceEpoch ~/ 1000,
      expiresAt: expiredIn30Minutes.millisecondsSinceEpoch ~/ 1000,
      structure: 'MILO',
    );
    final isValid = token.isValid(now: now, maxLivingTimeInSeconds: maxLivingTimeInSeconds);
    expect(isValid, expected);
  }

  group("without max living time", () {
    test('is valid return true if token expires in more than 15 seconds', () {
      assertIsValid(now: oneSecondBeforeExpiration, expected: true);
    });

    test('is valid return false if token expires in less than 15 seconds', () {
      assertIsValid(now: oneSecondAfterExpiration, expected: false);
    });
  });

  group("with max living time", () {
    test('is valid return true if token expires in more than 15 seconds and is below max living time', () {
      assertIsValid(
        now: oneSecondBeforeMaxLivingTime,
        maxLivingTimeInSeconds: maxLivingTime5Minutes,
        expected: true,
      );
    });

    test('is valid return false if token expires in more than 15 seconds but is above max living time', () {
      assertIsValid(
        now: oneSecondAfterMaxLivingTime,
        maxLivingTimeInSeconds: maxLivingTime5Minutes,
        expected: false,
      );
    });
  });
}
