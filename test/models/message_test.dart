import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/chat/message.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';

import '../doubles/dummies.dart';

void main() {
  test("toJson when message has encrypted content without piece jointe should decrypt it", () {
    // Given
    final chatCryptoSpy = _FakeChatCrypto();

    // When
    final message = Message.fromJson(
      "uid",
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
          id: "uid",
          content: "toto-chiffré-déchiffré",
          creationDate: DateTime(2021, 7, 30, 9, 43, 9),
          sentBy: Sender.jeune,
          type: MessageType.message,
          sendingStatus: MessageSendingStatus.sent,
          contentStatus: MessageContentStatus.content,
          pieceJointes: [],
        ));
  });

  test("toJson when message has encrypted content with piece jointe should decrypt it", () {
    // Given
    final chatCryptoSpy = _FakeChatCrypto();

    // When
    final message = Message.fromJson(
      "uid",
      {
        "content": "toto-chiffré",
        "creationDate": Timestamp.fromDate(DateTime(2021, 7, 30, 9, 43, 9)),
        "iv": "ivvv",
        "sentBy": "jeune",
        "piecesJointes": [
          {
            "id": "id-pj-343",
            "nom": "nom-secretement-chiffré",
            "statut": "analyse_en_cours",
          },
        ]
      },
      chatCryptoSpy,
      DummyCrashlytics(),
    );

    // Then
    expect(
        message,
        Message(
          id: "uid",
          content: "toto-chiffré-déchiffré",
          creationDate: DateTime(2021, 7, 30, 9, 43, 9),
          sentBy: Sender.jeune,
          type: MessageType.message,
          sendingStatus: MessageSendingStatus.sent,
          contentStatus: MessageContentStatus.content,
          pieceJointes: [
            PieceJointe(
              "id-pj-343",
              "nom-secretement-chiffré-déchiffré",
              PieceJointeAnalyseStatut.enCours,
            )
          ],
        ));
  });

  test("toJson when message status is deleted", () {
    // Given
    final chatCryptoSpy = _FakeChatCrypto();

    // When
    final message = Message.fromJson(
      "uid",
      {
        "content": "qsldmkjqslmdj",
        "creationDate": Timestamp.fromDate(DateTime(2021, 7, 30, 9, 43, 9)),
        "iv": "ivvv",
        "sentBy": "jeune",
        "type": "MESSAGE",
        "status": "deleted"
      },
      chatCryptoSpy,
      DummyCrashlytics(),
    );

    // Then
    expect(message!.contentStatus, MessageContentStatus.deleted);
  });

  test("toJson when message status is edited", () {
    // Given
    final chatCryptoSpy = _FakeChatCrypto();

    // When
    final message = Message.fromJson(
      "uid",
      {
        "content": "qsldmkjqslmdj",
        "creationDate": Timestamp.fromDate(DateTime(2021, 7, 30, 9, 43, 9)),
        "iv": "ivvv",
        "sentBy": "jeune",
        "type": "MESSAGE",
        "status": "edited"
      },
      chatCryptoSpy,
      DummyCrashlytics(),
    );

    // Then
    expect(message!.contentStatus, MessageContentStatus.edited);
  });

  test("toJson when message typed as MESSAGE", () {
    // Given
    final chatCryptoSpy = _FakeChatCrypto();

    // When
    final message = Message.fromJson(
      "uid",
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

  group("toJson MESSAGE_OFFRE", () {
    void assertMessageOffreWithType({required String? offreTypeJson, required OffreType offreType}) {
      test("with type $offreTypeJson", () {
        // Given
        final chatCryptoSpy = _FakeChatCrypto();

        // When
        final message = Message.fromJson(
          "uid",
          {
            "content": "toto-chiffré",
            "creationDate": Timestamp.fromDate(DateTime(2021, 7, 30, 9, 43, 9)),
            "iv": "ivvv",
            "sentBy": "jeune",
            "type": "MESSAGE_OFFRE",
            "offre": {
              "id": "343",
              "titre": "Chevalier",
              "type": offreTypeJson,
            },
          },
          chatCryptoSpy,
          DummyCrashlytics(),
        );

        // Then
        expect(
            message,
            Message(
              id: "uid",
              content: "toto-chiffré-déchiffré",
              creationDate: DateTime(2021, 7, 30, 9, 43, 9),
              sentBy: Sender.jeune,
              type: MessageType.offre,
              sendingStatus: MessageSendingStatus.sent,
              contentStatus: MessageContentStatus.content,
              pieceJointes: [],
              offre: MessageOffre(
                "343",
                "Chevalier",
                offreType,
              ),
            ));
      });
    }

    assertMessageOffreWithType(offreTypeJson: null, offreType: OffreType.emploi);
    assertMessageOffreWithType(offreTypeJson: "EMPLOI", offreType: OffreType.emploi);
    assertMessageOffreWithType(offreTypeJson: "ALTERNANCE", offreType: OffreType.alternance);
    assertMessageOffreWithType(offreTypeJson: "IMMERSION", offreType: OffreType.immersion);
    assertMessageOffreWithType(offreTypeJson: "SERVICE_CIVIQUE", offreType: OffreType.civique);
  });

  group("toJson MESSAGE_EVENEMENT", () {
    void assertMessageEventWithType({required String rdvTypeJson, required RendezvousTypeCode rdvType}) {
      test("with type $rdvTypeJson", () {
        // Given
        final chatCryptoSpy = _FakeChatCrypto();

        // When
        final message = Message.fromJson(
          "uid",
          {
            "content": "toto-chiffré",
            "creationDate": Timestamp.fromDate(DateTime(2021, 7, 30, 9, 43, 9)),
            "iv": "ivvv",
            "sentBy": "jeune",
            "type": "MESSAGE_EVENEMENT",
            "evenement": {
              "id": "343",
              "type": rdvTypeJson,
              "titre": "Chevalier",
            },
          },
          chatCryptoSpy,
          DummyCrashlytics(),
        );

        // Then
        expect(
            message,
            Message(
              id: "uid",
              content: "toto-chiffré-déchiffré",
              creationDate: DateTime(2021, 7, 30, 9, 43, 9),
              sentBy: Sender.jeune,
              type: MessageType.event,
              sendingStatus: MessageSendingStatus.sent,
              contentStatus: MessageContentStatus.content,
              pieceJointes: [],
              event: Event(
                id: "343",
                titre: "Chevalier",
                type: rdvType,
              ),
            ));
      });
    }

    assertMessageEventWithType(rdvTypeJson: "ATELIER", rdvType: RendezvousTypeCode.ATELIER);
    assertMessageEventWithType(
      rdvTypeJson: "ENTRETIEN_INDIVIDUEL_CONSEILLER",
      rdvType: RendezvousTypeCode.ENTRETIEN_INDIVIDUEL_CONSEILLER,
    );
  });

  group('fromJson when message typed as MESSAGE_EVENEMENT_EMPLOI', () {
    test("should return message with ChatEvenementEmploi", () {
      // Given
      final chatCryptoSpy = _FakeChatCrypto();

      // When
      final message = Message.fromJson(
        "uid",
        {
          "content": "toto-chiffré",
          "creationDate": Timestamp.fromDate(DateTime(2022, 7, 30, 9, 43, 9)),
          "iv": "ivvv",
          "sentBy": "jeune",
          "type": "MESSAGE_EVENEMENT_EMPLOI",
          "evenementEmploi": {
            "id": "343",
            "titre": "Salon de l'emploi",
            "url": "https://www.mon-url.fr",
          },
        },
        chatCryptoSpy,
        DummyCrashlytics(),
      );

      // Then
      expect(
          message,
          Message(
            id: "uid",
            content: "toto-chiffré-déchiffré",
            creationDate: DateTime(2022, 7, 30, 9, 43, 9),
            sentBy: Sender.jeune,
            type: MessageType.evenementEmploi,
            sendingStatus: MessageSendingStatus.sent,
            contentStatus: MessageContentStatus.content,
            pieceJointes: [],
            evenementEmploi: ChatEvenementEmploi(
              "343",
              "Salon de l'emploi",
              "https://www.mon-url.fr",
            ),
          ));
    });
  });

  test("toJson when message typed as NOUVEAU_CONSEILLER", () {
    // Given
    final chatCryptoSpy = _FakeChatCrypto();

    // When
    final message = Message.fromJson(
      "uid",
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
      "uid",
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
      "uid",
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
      "uid",
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

  group('PieceJointeAnalyseStatut', () {
    test('should return piece jointe statut enCours', () {
      // Given
      const String statut = "analyse_en_cours";

      // When
      final result = PieceJointeAnalyseStatut.fromJson(statut);

      // Then
      expect(result, PieceJointeAnalyseStatut.enCours);
    });
    test('should return piece jointe statut aFaire', () {
      // Given
      const String statut = "analyse_a_faire";

      // When
      final result = PieceJointeAnalyseStatut.fromJson(statut);

      // Then
      expect(result, PieceJointeAnalyseStatut.aFaire);
    });
    test('should return piece jointe statut valide', () {
      // Given
      const String statut = "valide";

      // When
      final result = PieceJointeAnalyseStatut.fromJson(statut);

      // Then
      expect(result, PieceJointeAnalyseStatut.valide);
    });
    test('should return piece jointe statut erreur', () {
      // Given
      const String statut = "erreur_analyse";

      // When
      final result = PieceJointeAnalyseStatut.fromJson(statut);

      // Then
      expect(result, PieceJointeAnalyseStatut.erreur);
    });
    test('should return piece jointe statut nonValide', () {
      // Given
      const String statut = "non_valide";

      // When
      final result = PieceJointeAnalyseStatut.fromJson(statut);

      // Then
      expect(result, PieceJointeAnalyseStatut.nonValide);
    });
    test('should return piece jointe statut expire', () {
      // Given
      const String statut = "expiree";

      // When
      final result = PieceJointeAnalyseStatut.fromJson(statut);

      // Then
      expect(result, PieceJointeAnalyseStatut.expiree);
    });
    test('should not return piece jointe status', () {
      // Given
      const String statut = "ineiaonhfei";

      // When
      final result = PieceJointeAnalyseStatut.fromJson(statut);

      // Then
      expect(result, null);
    });
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
