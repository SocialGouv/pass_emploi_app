import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/conseiller_messages_info.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';

class ChatRepository {
  final Crashlytics _crashlytics;
  late final String _collectionPath;
  final ChatCrypto _chatCrypto;

  ChatRepository(this._chatCrypto, this._crashlytics) {
    this._collectionPath = "chat";
  }

  Stream<List<Message>> messagesStream(String userId) async* {
    final chatDocumentId = await _getChatDocumentId(userId);
    if (chatDocumentId == null) return;

    final Stream<List<Message>> stream = _chatCollection(chatDocumentId)
        .collection('messages')
        .orderBy('creationDate')
        .snapshots()
        .map((snapshot) => _getMessageList(snapshot))
        .distinct();
    await for (final messages in stream) yield messages;
  }

  Stream<ConseillerMessageInfo> chatStatusStream(String userId) async* {
    final chatDocumentId = await _getChatDocumentId(userId);
    if (chatDocumentId == null) return;

    final Stream<ConseillerMessageInfo> stream = _chatCollection(chatDocumentId)
        .snapshots() //
        .map((snapshot) => _toConseillerMessageInfo(snapshot));

    await for (final info in stream) yield info;
  }

  Future<void> sendMessage(String userId, String message) async {
    final chatDocumentId = await _getChatDocumentId(userId);
    if (chatDocumentId == null) return;

    final messageCreationDate = FieldValue.serverTimestamp();
    final encryptedMessage = _chatCrypto.encrypt(message);
    FirebaseFirestore.instance
        .runTransaction((transaction) async {
          final newDocId = _chatCollection(chatDocumentId).collection('messages').doc(null);
          transaction
            ..set(newDocId, {
              'iv': encryptedMessage.base64InitializationVector,
              'content': encryptedMessage.base64Message,
              'sentBy': "jeune",
              'creationDate': messageCreationDate,
            })
            ..update(_chatCollection(chatDocumentId), {
              'lastMessageContent': encryptedMessage.base64Message,
              'lastMessageIv': encryptedMessage.base64InitializationVector,
              'lastMessageSentBy': "jeune",
              'lastMessageSentAt': messageCreationDate,
              'seenByConseiller': false,
            });
        })
        .then((value) => debugPrint("New message sent $message && chat status updated"))
        .catchError((e, stack) => _crashlytics.recordNonNetworkException(e, stack));
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
        .then((value) => debugPrint("Last message seen updated"))
        .catchError((e, stack) => _crashlytics.recordNonNetworkException(e, stack));
  }

  Future<String?> _getChatDocumentId(String userId) async {
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
      data['newConseillerMessageCount'],
      lastConseillerReading != null ? (lastConseillerReading as Timestamp).toDate() : null,
    );
  }

  List<Message> _getMessageList(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs
        .map((document) => Message.fromJson(document, _chatCrypto, _crashlytics))
        .whereType<Message>()
        .toList();
  }
}
