import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/redux/actions/chat_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

class ChatRepository {
  String _collectionPath = '';
  StreamSubscription<QuerySnapshot>? _messagesSubscription;
  StreamSubscription<DocumentSnapshot>? _chatStatusSubscription;
  String? _chatDocumentId;

  ChatRepository(String firebaseEnvironmentPrefix) {
    this._collectionPath = firebaseEnvironmentPrefix + "-chat";
  }

  // TODO unsubscribe depending on app lifecycle
  subscribeToMessages(String userId, Store<AppState> store) async {
    unsubscribeToMessages();
    store.dispatch(ChatLoadingAction());

    final chats =
        await FirebaseFirestore.instance.collection(_collectionPath).where('jeuneId', isEqualTo: userId).get();
    _chatDocumentId = chats.docs.first.id;

    final Stream<QuerySnapshot> messageStream = _messagesCollection().orderBy('creationDate').snapshots();
    _messagesSubscription = messageStream.listen(
      (QuerySnapshot snapshot) {
        final messages = snapshot.docs.map((DocumentSnapshot document) => Message.fromJson(document)).toList();
        store.dispatch(ChatSuccessAction(messages));
      },
      onError: (Object error, StackTrace stackTrace) {
        store.dispatch(ChatFailureAction());
      },
      cancelOnError: false,
    );

    final Stream<DocumentSnapshot> chatStatusStream = _chatStatusCollection().snapshots();
    _chatStatusSubscription = chatStatusStream.listen(
      (DocumentSnapshot snapshot) {
        final Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
        final unreadMessageCount = data['newConseillerMessageCount'];
        final lastConseillerReading = data['lastConseillerReading'];
        final DateTime? dateTime = lastConseillerReading != null ? (lastConseillerReading as Timestamp).toDate() : null;
        store.dispatch(ChatConseillerMessageAction(unreadMessageCount, dateTime));
      },
      onError: (Object error, StackTrace stackTrace) {
        print("Chat status error");
      },
      cancelOnError: false,
    );
  }

  unsubscribeToMessages() {
    _messagesSubscription?.cancel();
    _chatStatusSubscription?.cancel();
  }

  sendMessage(String message) async {
    final messageCreationDate = FieldValue.serverTimestamp();

    _messagesCollection()
        .add({
          'content': message,
          'sentBy': "jeune",
          'creationDate': messageCreationDate,
        })
        .then((value) => print("New message sent $message"))
        .catchError((error) => print("Failed to send message: $error"));

    _chatStatusCollection()
        .update({
          'lastMessageContent': message,
          'lastMessageSentBy': "jeune",
          'lastMessageSentAt': messageCreationDate,
          'seenByConseiller': false,
        })
        .then((value) => print("Chat status updated"))
        .catchError((error) => print("Failed to update chat status: $error"));
  }

  setLastMessageSeen() {
    final seenByJeuneAt = FieldValue.serverTimestamp();
    _chatStatusCollection()
        .update({
          'newConseillerMessageCount': 0,
          'lastJeuneReading': seenByJeuneAt,
        })
        .then((value) => print("Last message seen updated"))
        .catchError((error) => print("Failed to update last message seen: $error"));
  }

  _messagesCollection() =>
      FirebaseFirestore.instance.collection(_collectionPath).doc(_chatDocumentId).collection('messages');

  _chatStatusCollection() => FirebaseFirestore.instance.collection(_collectionPath).doc(_chatDocumentId);
}
