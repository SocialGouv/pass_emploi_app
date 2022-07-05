import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';

import '../doubles/dummies.dart';

void main() {
  test("toJson when message has encrypted content without piece jointe should decrypt it", () {
    // Given
    final chatCryptoSpy = _FakeChatCrypto();

    // When
    final message = Message.fromJson(
      {
        "content": "toto-chiffré",
        "creationDate": Timestamp.fromDate(DateTime(2021, 7, 30, 9, 43, 9)),
        "iv": "ivvv",
        "sentBy": "jeune",
      },
      chatCryptoSpy,
      DummyCrashlytics(),
    );

    // Then
    expect(
        message,
        Message(
          "toto-chiffré-déchiffré",
          DateTime(2021, 7, 30, 9, 43, 9),
          Sender.jeune,
          MessageType.message,
          [],
        ));
  });

  test("toJson when message has encrypted content with piece jointe should decrypt it", () {
    // Given
    final chatCryptoSpy = _FakeChatCrypto();

    // When
    final message = Message.fromJson(
      {
        "content": "toto-chiffré",
        "creationDate": Timestamp.fromDate(DateTime(2021, 7, 30, 9, 43, 9)),
        "iv": "ivvv",
        "sentBy": "jeune",
        "piecesJointes": [
          {"id": "id-pj-343", "nom": "nom-secretement-chiffré"},
        ]
      },
      chatCryptoSpy,
      DummyCrashlytics(),
    );

    // Then
    expect(
        message,
        Message(
          "toto-chiffré-déchiffré",
          DateTime(2021, 7, 30, 9, 43, 9),
          Sender.jeune,
          MessageType.message,
          [
            PieceJointe(
              "id-pj-343",
              "nom-secretement-chiffré-déchiffré",
            )
          ],
        ));
  });

  test("toJson when message typed as MESSAGE", () {
    // Given
    final chatCryptoSpy = _FakeChatCrypto();

    // When
    final message = Message.fromJson(
      {
        "content": "qsldmkjqslmdj",
        "creationDate": Timestamp.fromDate(DateTime(2021, 7, 30, 9, 43, 9)),
        "iv": "ivvv",
        "sentBy": "jeune",
        "type": "MESSAGE"
      },
      chatCryptoSpy,
      DummyCrashlytics(),
    );

    // Then
    expect(message!.type, MessageType.message);
  });

  test("toJson MESSAGE_OFFRE", () {
    // Given
    final chatCryptoSpy = _FakeChatCrypto();

    // When
    final message = Message.fromJson(
      {
        "content": "toto-chiffré",
        "creationDate": Timestamp.fromDate(DateTime(2021, 7, 30, 9, 43, 9)),
        "iv": "ivvv",
        "sentBy": "jeune",
        "type": "MESSAGE_OFFRE",
        "idOffre": "343",
        "titreOffre": "Chevalier",
      },
      chatCryptoSpy,
      DummyCrashlytics(),
    );

    // Then
    expect(
        message,
        Message(
          "toto-chiffré-déchiffré",
          DateTime(2021, 7, 30, 9, 43, 9),
          Sender.jeune,
          MessageType.offre,
          [],
          "343",
          "Chevalier",
        ));
  });

  test("toJson when message typed as NOUVEAU_CONSEILLER", () {
    // Given
    final chatCryptoSpy = _FakeChatCrypto();

    // When
    final message = Message.fromJson(
      {
        "content": "qsldmkjqslmdj",
        "creationDate": Timestamp.fromDate(DateTime(2021, 7, 30, 9, 43, 9)),
        "iv": "ivvv",
        "sentBy": "jeune",
        "type": "NOUVEAU_CONSEILLER"
      },
      chatCryptoSpy,
      DummyCrashlytics(),
    );

    // Then
    expect(message!.type, MessageType.nouveauConseiller);
  });

  test("toJson when message type is unknown", () {
    // Given
    final chatCryptoSpy = _FakeChatCrypto();

    // When
    final message = Message.fromJson(
      {
        "content": "qsldmkjqslmdj",
        "creationDate": Timestamp.fromDate(DateTime(2021, 7, 30, 9, 43, 9)),
        "iv": "ivvv",
        "sentBy": "jeune",
        "type": "PIECE_JOINTE"
      },
      chatCryptoSpy,
      DummyCrashlytics(),
    );

    // Then
    expect(message!.type, MessageType.inconnu);
  });

  test("toJson when message has no iv should return null", () {
    // Given
    final chatCryptoSpy = _FakeChatCrypto();

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

class _FakeChatCrypto extends ChatCrypto {
  @override
  String decrypt(EncryptedTextWithIv encrypted) {
    return "${encrypted.base64Message}-déchiffré";
  }
}

class ChatCryptoFailureStub extends ChatCrypto {
  @override
  String decrypt(EncryptedTextWithIv encrypted) {
    throw Exception("");
  }
}
