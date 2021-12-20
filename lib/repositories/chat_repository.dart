import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pass_emploi_app/models/conseiller_messages_info.dart';
import 'package:pass_emploi_app/models/message.dart';

class ChatRepository {
  late final String _collectionPath;

  ChatRepository(String firebaseEnvironmentPrefix) {
    this._collectionPath = firebaseEnvironmentPrefix + "-chat";
  }

  Stream<List<Message>> messagesStream(String userId) async* {
    final chatDocumentId = await _getChatDocumentId(userId);
    if (chatDocumentId == null) return;

    final Stream<List<Message>> stream = _chatCollection(chatDocumentId)
        .collection('messages')
        .orderBy('creationDate')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) => Message.fromJson(document)).toList())
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
    FirebaseFirestore.instance
        .runTransaction((transaction) async {
          final newDocId = _chatCollection(chatDocumentId).collection('messages').doc(null);
          transaction
            ..set(newDocId, {
              'content': message,
              'sentBy': "jeune",
              'creationDate': messageCreationDate,
            })
            ..update(_chatCollection(chatDocumentId), {
              'lastMessageContent': message,
              'lastMessageSentBy': "jeune",
              'lastMessageSentAt': messageCreationDate,
              'seenByConseiller': false,
            });
        })
        .then((value) => debugPrint("New message sent $message && chat status updated"))
        .catchError((error) => debugPrint("Failed to send message or update chat status: $error "));
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
        .catchError((error) => debugPrint("Failed to update last message seen: $error"));
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
}
