import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';

void main() {
  test("chat crypto should encrypt message and then decrypt it", () {
    // Given
    const String message = "mon super message";
    final chatCrypto = ChatCrypto();
    chatCrypto.setKey("7x!A%C*F-JaNdRgUkXp2s5v8y/B?E(G+");

    // When
    final encrypted = chatCrypto.encrypt(message);
    final decrypted = chatCrypto.decrypt(encrypted);

    // Then
    expect(encrypted.base64Message != base64.encode(utf8.encode(message)), true);
    expect(message, decrypted);
  });

  test("chat crypto should throw exception when trying to decrypt without a key", () {
    // Given
    final chatCrypto = ChatCrypto();

    // When
    expect(
      () => chatCrypto.decrypt(EncryptedTextWithIv("", "")),
      // Then
      throwsException,
    );
  });

  test("chat crypto should throw exception when trying to encrypt without a key", () {
    // Given
    final chatCrypto = ChatCrypto();

    // When
    expect(
      () => chatCrypto.encrypt("toto"),
      // Then
      throwsException,
    );
  });

  test('should encrypt with given iv', () {
    // Given
    const String message = "mon super message";
    final chatCrypto = ChatCrypto();
    chatCrypto.setKey("7x!A%C*F-JaNdRgUkXp2s5v8y/B?E(G+");
    final encrypted = chatCrypto.encrypt(message);

    // When
    final encryptedWithIv = chatCrypto.encryptWithIv(message, encrypted.base64InitializationVector);
    final decrypted = chatCrypto.decrypt(EncryptedTextWithIv(encrypted.base64InitializationVector, encryptedWithIv));

    // Then
    expect(encrypted.base64Message != base64.encode(utf8.encode(message)), true);
    expect(message, decrypted);
  });
}
