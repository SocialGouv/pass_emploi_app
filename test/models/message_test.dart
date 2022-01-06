import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';

import '../doubles/dummies.dart';

main() {
  test("toJson when message has encrypted content should decrypt it", () {
    // Given
    final chatCryptoSpy = _ChatCryptoSpy();

    // When
    final message = Message.fromJson(
      {
        "content": "qsldmkjqslmdj",
        "creationDate": Timestamp.fromDate(DateTime(2021, 7, 30, 9, 43, 9)),
        "iv": "ivvv",
        "sentBy": "jeune"
      },
      chatCryptoSpy,
      DummyCrashlytics(),
    );

    // Then
    expect(chatCryptoSpy.content, "qsldmkjqslmdj");
    expect(chatCryptoSpy.iv, "ivvv");
    expect(message, Message("toto", DateTime(2021, 7, 30, 9, 43, 9), Sender.jeune));
  });

  test("toJson when message has no iv should return null", () {
    // Given
    final chatCryptoSpy = _ChatCryptoSpy();

    // When
    final message = Message.fromJson(
      {
        "content": "qsldmkjqslmdj",
        "creationDate": Timestamp.fromDate(DateTime(2021, 7, 30, 9, 43, 9)),
        "sentBy": "jeune"
      },
      chatCryptoSpy,
      DummyCrashlytics(),
    );

    // Then
    expect(message, isNull);
  });

  test("toJson when message decryption fails should return null", () {
    // Given
    final chatCryptoFailureStub = ChatCryptoFailureStub();

    // When
    final message = Message.fromJson(
      {
        "content": "qsldmkjqslmdj",
        "creationDate": Timestamp.fromDate(DateTime(2021, 7, 30, 9, 43, 9)),
        "sentBy": "jeune"
      },
      chatCryptoFailureStub,
      DummyCrashlytics(),
    );

    // Then
    expect(message, isNull);
  });
}

class _ChatCryptoSpy extends ChatCrypto {
  var content;
  var iv;

  @override
  String decrypt(EncryptedTextWithIv encrypted) {
    content = encrypted.base64Message;
    iv = encrypted.base64InitializationVector;
    return "toto";
  }
}

class ChatCryptoFailureStub extends ChatCrypto {
  @override
  String decrypt(EncryptedTextWithIv encrypted) {
    throw Exception("");
  }
}
