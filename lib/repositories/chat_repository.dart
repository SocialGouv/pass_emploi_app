import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_middleware.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/models/conseiller_messages_info.dart';
import 'package:pass_emploi_app/models/event_partage.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/models/offre_partagee.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/utils/log.dart';

const String _collectionPath = "chat";

class ChatRepository {
  final Crashlytics _crashlytics;
  final ChatCrypto _chatCrypto;
  final ModeDemoRepository _demoRepository;

  ChatRepository(this._chatCrypto, this._crashlytics, this._demoRepository);

  Stream<List<Message>> messagesStream(String userId) async* {
    if (!_chatCrypto.isInitialized()) {
      throw ChatNotInitializedError();
    }
    final chatDocumentId = await _getChatDocumentId(userId);
    if (chatDocumentId == null) return;

    final Stream<List<Message>> stream = _chatCollection(chatDocumentId)
        .collection('messages')
        .orderBy('creationDate')
        .snapshots()
        .map((snapshot) => _getMessageList(snapshot))
        .distinct();
    await for (final messages in stream) {
      yield messages;
    }
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
        .then((value) => Log.d("New message sent $message && chat status updated"))
        .catchError((e, StackTrace stack) => _crashlytics.recordNonNetworkException(e, stack));
  }

  Future<bool> sendOffrePartagee(String userId, OffrePartagee offrePartagee) async {
    final chatDocumentId = await _getChatDocumentId(userId);
    if (chatDocumentId == null) return false;

    final messageCreationDate = FieldValue.serverTimestamp();
    final encryptedMessage = _chatCrypto.encrypt(offrePartagee.message);
    final succeed = await FirebaseFirestore.instance
        .runTransaction((transaction) async {
          final newDocId = _chatCollection(chatDocumentId).collection('messages').doc(null);
          transaction
            ..set(newDocId, {
              'iv': encryptedMessage.base64InitializationVector,
              'content': encryptedMessage.base64Message,
              'sentBy': "jeune",
              'creationDate': messageCreationDate,
              'offre' : {
                'id': offrePartagee.id,
                'lien': offrePartagee.url,
                'titre': offrePartagee.titre,
                'type': _offreTypeToString(offrePartagee.type),
              },
              'type': "MESSAGE_OFFRE",
            })
            ..update(_chatCollection(chatDocumentId), {
              'lastMessageContent': encryptedMessage.base64Message,
              'lastMessageIv': encryptedMessage.base64InitializationVector,
              'lastMessageSentBy': "jeune",
              'lastMessageSentAt': messageCreationDate,
              'seenByConseiller': false,
            });
        })
        .then((value) {
          Log.d("New message sent ${offrePartagee.message} with offre ${offrePartagee.titre} && chat status updated");
          return true;
        })
        .catchError((e, StackTrace stack) {
          _crashlytics.recordNonNetworkException(e, stack);
          return false;
        });
    return succeed;
  }

  Future<bool> sendEventPartage(String userId, EventPartage eventPartage) async {
    final chatDocumentId = await _getChatDocumentId(userId);
    if (chatDocumentId == null) return false;

    final messageCreationDate = FieldValue.serverTimestamp();
    final encryptedMessage = _chatCrypto.encrypt(eventPartage.message);
    final succeed = await FirebaseFirestore.instance
        .runTransaction((transaction) async {
          final newDocId = _chatCollection(chatDocumentId).collection('messages').doc(null);
          transaction
            ..set(newDocId, {
              'iv': encryptedMessage.base64InitializationVector,
              'content': encryptedMessage.base64Message,
              'sentBy': "jeune",
              'creationDate': messageCreationDate,
              'evenement' : {
                'id': eventPartage.id,
                'type': _rdvTypeToString(eventPartage.type),
                'titre': eventPartage.titre,
                'date': eventPartage.date.toIso8601WithOffsetDateTime(),
              },
              'type': "MESSAGE_EVENEMENT",
            })
            ..update(_chatCollection(chatDocumentId), {
              'lastMessageContent': encryptedMessage.base64Message,
              'lastMessageIv': encryptedMessage.base64InitializationVector,
              'lastMessageSentBy': "jeune",
              'lastMessageSentAt': messageCreationDate,
              'seenByConseiller': false,
            });
        })
        .then((value) {
          Log.d("New message sent ${eventPartage.message} with event ${eventPartage.titre} && chat status updated");
          return true;
        })
        .catchError((e, StackTrace stack) {
          _crashlytics.recordNonNetworkException(e, stack);
          return false;
        });
    return succeed;
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
    if (_demoRepository.getModeDemo()) {
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
      data['newConseillerMessageCount'] as int?,
      lastConseillerReading != null ? (lastConseillerReading as Timestamp).toDate() : null,
    );
  }

  List<Message> _getMessageList(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs
        .map((document) => Message.fromJson(document.data(), _chatCrypto, _crashlytics))
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
