import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_middleware.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/models/chat/message.dart';
import 'package:pass_emploi_app/models/chat/offre_partagee.dart';
import 'package:pass_emploi_app/models/conseiller_messages_info.dart';
import 'package:pass_emploi_app/models/evenement_emploi_partage.dart';
import 'package:pass_emploi_app/models/event_partage.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/session_milo_partage.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/utils/iterable_extensions.dart';
import 'package:pass_emploi_app/utils/log.dart';

const String _collectionPath = "chat";

class ChatRepository {
  final Crashlytics _crashlytics;
  final ChatCrypto _chatCrypto;
  final ModeDemoRepository _demoRepository;

  int get numberOfStreamedMessage => 20;

  int get numberOfHistoryMessage => 20;

  ChatRepository(this._chatCrypto, this._crashlytics, this._demoRepository);

  Stream<List<Message>> messagesStream(String userId) async* {
    if (!_chatCrypto.isInitialized()) {
      throw ChatNotInitializedError();
    }

    final chatDocumentId = await _getChatDocumentId(userId);
    if (chatDocumentId == null) return;

    final Stream<List<Message>> stream = _chatCollection(chatDocumentId)
        .collection('messages')
        .orderBy('creationDate', descending: true)
        .limit(numberOfStreamedMessage)
        .snapshots()
        .map((snapshot) => _getMessageList(snapshot))
        .distinct();
    await for (final messages in stream) {
      yield messages;
    }
  }

  Future<List<Message>> oldMessages(String userId, DateTime date) async {
    if (!_chatCrypto.isInitialized()) {
      throw ChatNotInitializedError();
    }

    final chatDocumentId = await _getChatDocumentId(userId);
    if (chatDocumentId == null) return [];

    final snapshot = await _chatCollection(chatDocumentId)
        .collection('messages')
        .orderBy('creationDate', descending: true)
        .startAfter([Timestamp.fromDate(date)])
        .limit(numberOfHistoryMessage)
        .get();

    return _getMessageList(snapshot).distinct().toList();
  }

  Stream<ConseillerMessageInfo> chatStatusStream(String userId) async* {
    final chatDocumentId = await _getChatDocumentId(userId);
    if (chatDocumentId == null) return;

    final Stream<ConseillerMessageInfo> stream = _chatCollection(chatDocumentId)
        .snapshots() //
        .map((snapshot) => _toConseillerMessageInfo(snapshot));

    await for (final info in stream) {
      yield info;
    }
  }

  Future<bool> _sendMessage({
    required String userId,
    required String message,
    String? messageId,
    Map<String, dynamic> customPayload = const {},
  }) async {
    final chatDocumentId = await _getChatDocumentId(userId);
    if (chatDocumentId == null) return false;

    final messageCreationDate = FieldValue.serverTimestamp();
    final encryptedMessage = _chatCrypto.encrypt(message);
    final succeed = await FirebaseFirestore.instance.runTransaction((transaction) async {
      final newDocId = _chatCollection(chatDocumentId).collection('messages').doc(messageId);
      transaction
        ..set(newDocId, {
          'iv': encryptedMessage.base64InitializationVector,
          'content': encryptedMessage.base64Message,
          'sentBy': "jeune",
          'creationDate': messageCreationDate,
          ...customPayload,
        })
        ..update(_chatCollection(chatDocumentId), {
          'lastMessageContent': encryptedMessage.base64Message,
          'lastMessageIv': encryptedMessage.base64InitializationVector,
          'lastMessageSentBy': "jeune",
          'lastMessageSentAt': messageCreationDate,
          'seenByConseiller': false,
        });
    }).then((value) {
      Log.d("New message sent $message && chat status updated");
      return true;
    }).catchError((e, StackTrace stack) {
      _crashlytics.recordNonNetworkException(e, stack);
      return false;
    });
    return succeed;
  }

  Future<bool> sendMessage(String userId, Message message) async {
    return _sendMessage(userId: userId, message: message.content, messageId: message.id);
  }

  Future<bool> deleteMessage(String userId, Message message, bool isLastMessage) async {
    const deletedMessageContent = '(message supprimé)';
    return await _updateMessage(
      userId: userId,
      content: deletedMessageContent,
      message: message,
      status: MessageContentStatus.deleted,
      shouldUpdateChat: isLastMessage,
    );
  }

  Future<bool> editMessage(String userId, Message message, bool isLastMessage, String content) async {
    return await _updateMessage(
      userId: userId,
      content: content,
      message: message,
      status: MessageContentStatus.edited,
      shouldUpdateChat: isLastMessage,
    );
  }

  Future<bool> _updateMessage({
    required String userId,
    required String content,
    required Message message,
    required MessageContentStatus status,
    required bool shouldUpdateChat,
  }) async {
    final chatDocumentId = await _getChatDocumentId(userId);
    if (chatDocumentId == null) return false;

    final iv = message.iv ?? "";
    final encryptedNewMessage = _chatCrypto.encryptWithIv(content, iv);

    final encryptedOldMessage = _chatCrypto.encryptWithIv(message.content, iv);

    final succeed = await FirebaseFirestore.instance.runTransaction((transaction) async {
      final messageRef = _chatCollection(chatDocumentId).collection('messages').doc(message.id);
      transaction.update(messageRef, {
        'content': encryptedNewMessage,
        'status': status.toJson,
      });

      final historyRef = messageRef.collection('history').doc();
      transaction.set(historyRef, {
        "date": FieldValue.serverTimestamp(),
        "previousContent": encryptedOldMessage,
      });

      if (shouldUpdateChat) {
        transaction.update(_chatCollection(chatDocumentId), {
          'lastMessageContent': encryptedNewMessage,
        });
      }
    }).then((value) {
      return true;
    }).catchError((e, StackTrace stack) {
      _crashlytics.recordNonNetworkException(e, stack);
      return false;
    });
    return succeed;
  }

  Future<bool> sendOffrePartagee(String userId, OffrePartagee offrePartagee) async {
    final customPayload = {
      'offre': {
        'id': offrePartagee.id,
        'lien': offrePartagee.url,
        'titre': offrePartagee.titre,
        'type': _offreTypeToString(offrePartagee.type),
      },
      'type': "MESSAGE_OFFRE",
    };
    return _sendMessage(userId: userId, message: offrePartagee.message, customPayload: customPayload);
  }

  Future<bool> sendEventPartage(String userId, EventPartage eventPartage) async {
    final customPayload = {
      'evenement': {
        'id': eventPartage.id,
        'type': _rdvTypeToString(eventPartage.type),
        'titre': eventPartage.titre,
        'date': eventPartage.date.toIso8601WithOffsetDateTime(),
      },
      'type': "MESSAGE_EVENEMENT",
    };
    return _sendMessage(userId: userId, message: eventPartage.message, customPayload: customPayload);
  }

  Future<bool> sendSessionMiloPartage(String userId, SessionMiloPartage sessionMiloPartage) async {
    final customPayload = {
      'sessionMilo': {
        'id': sessionMiloPartage.id,
        'titre': sessionMiloPartage.titre,
      },
      'type': "MESSAGE_SESSION_MILO",
    };
    return _sendMessage(userId: userId, message: sessionMiloPartage.message, customPayload: customPayload);
  }

  Future<bool> sendEvenementEmploiPartage(String userId, EvenementEmploiPartage emploiPartage) async {
    final customPayload = {
      'evenementEmploi': {
        'id': emploiPartage.id,
        'titre': emploiPartage.titre,
        'url': emploiPartage.url,
      },
      'type': "MESSAGE_EVENEMENT_EMPLOI",
    };
    return _sendMessage(userId: userId, message: emploiPartage.message, customPayload: customPayload);
  }

  Future<void> setLastMessageSeen(String userId) async {
    final chatDocumentId = await _getChatDocumentId(userId);
    if (chatDocumentId == null) return;

    final seenByJeuneAt = FieldValue.serverTimestamp();
    _chatCollection(chatDocumentId)
        .update({
          'newConseillerMessageCount': 0,
          'lastJeuneReading': seenByJeuneAt,
        })
        .then((value) => Log.d("Last message seen updated"))
        .catchError((e, StackTrace stack) => _crashlytics.recordNonNetworkException(e, stack));
  }

  Future<String?> _getChatDocumentId(String userId) async {
    if (_demoRepository.isModeDemo()) {
      return null;
    }
    final chats =
        await FirebaseFirestore.instance.collection(_collectionPath).where('jeuneId', isEqualTo: userId).get();
    return chats.docs.first.id;
  }

  DocumentReference<Map<String, dynamic>> _chatCollection(String chatDocumentId) {
    return FirebaseFirestore.instance.collection(_collectionPath).doc(chatDocumentId);
  }

  ConseillerMessageInfo _toConseillerMessageInfo(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final Map<String, dynamic> data = snapshot.data()!;
    final lastConseillerReading = data['lastConseillerReading'];
    return ConseillerMessageInfo(
      (data['newConseillerMessageCount'] as int? ?? 0) > 0,
      lastConseillerReading != null ? (lastConseillerReading as Timestamp).toDate() : null,
    );
  }

  List<Message> _getMessageList(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs
        .map((document) => Message.fromJson(document.id, document.data(), _chatCrypto, _crashlytics))
        .whereType<Message>()
        .toList();
  }

  String _offreTypeToString(OffreType type) {
    switch (type) {
      case OffreType.alternance:
        return "ALTERNANCE";
      case OffreType.emploi:
        return "EMPLOI";
      default:
        return "INCONU";
    }
  }

  String _rdvTypeToString(RendezvousType type) {
    switch (type.code) {
      case RendezvousTypeCode.ACTIVITE_EXTERIEURES:
        return "ACTIVITE_EXTERIEURES";
      case RendezvousTypeCode.ATELIER:
        return "ATELIER";
      case RendezvousTypeCode.ENTRETIEN_INDIVIDUEL_CONSEILLER:
        return "ENTRETIEN_INDIVIDUEL_CONSEILLER";
      case RendezvousTypeCode.ENTRETIEN_PARTENAIRE:
        return "ENTRETIEN_PARTENAIRE";
      case RendezvousTypeCode.INFORMATION_COLLECTIVE:
        return "INFORMATION_COLLECTIVE";
      case RendezvousTypeCode.VISITE:
        return "VISITE";
      case RendezvousTypeCode.PRESTATION:
        return "PRESTATION";
      case RendezvousTypeCode.AUTRE:
        return "AUTRE";
    }
  }
}
