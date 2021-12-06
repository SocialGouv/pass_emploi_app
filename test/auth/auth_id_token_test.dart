import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';

void main() {
  test('is valid return true if token expires in more than 15 seconds', () {
    _assertIsValid(DateTime.now().add(Duration(seconds: 16)).millisecondsSinceEpoch ~/ 1000, true);
  });

  test('is valid return false if token expires in less than 15 seconds', () {
    _assertIsValid(DateTime.now().add(Duration(seconds: 14)).millisecondsSinceEpoch ~/ 1000, false);
  });

  test('is valid return false if token is expired', () {
    _assertIsValid(DateTime(2021).millisecondsSinceEpoch ~/ 1000, false);
  });
}

void _assertIsValid(int expiresAt, bool expected) {
  expect(AuthIdToken(userId: "", lastName: "", firstName: "", expiresAt: expiresAt).isValid(), expected);
}
