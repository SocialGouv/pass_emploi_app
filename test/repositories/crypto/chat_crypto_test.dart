import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';

main() {

  test("chat crypto should encrypt message and then decrypt it", () {
    // Given
    final String message = "mon super message";
    final chatCrypto = ChatCrypto("7x!A%C*F-JaNdRgUkXp2s5v8y/B?E(G+");

    // When
    final encrypted = chatCrypto.encrypt(message);
    final decrypted = chatCrypto.decrypt(encrypted);

    // Then
    expect(encrypted.base64Message != base64.encode(utf8.encode(message)), true);
    expect(message, decrypted);
  });

}