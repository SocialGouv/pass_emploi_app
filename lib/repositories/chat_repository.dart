import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/redux/actions/chat_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

class ChatRepository {
  String _collectionPath = '';
  StreamSubscription<QuerySnapshot>? _messagesSubscription;
  StreamSubscription<DocumentSnapshot>? _chatStatusSubscription;

  ChatRepository(String firebaseEnvironmentPrefix) {
    this._collectionPath = firebaseEnvironmentPrefix + "-chat";
  }

  subscribeToMessages(String userId, Store<AppState> store) async {
    store.dispatch(ChatLoadingAction()); //TODO: Sortir les actions

    final chats =
        await FirebaseFirestore.instance.collection(_collectionPath).where('jeuneId', isEqualTo: userId).get();
    final chatDocumentId = chats.docs.first.id;
    final messageCollection = FirebaseFirestore.instance.collection(_collectionPath).doc(chatDocumentId).collection('messages');
    final Stream<QuerySnapshot> messageStream = messageCollection.orderBy('creationDate').snapshots();

    _messagesSubscription = messageStream.listen(
      (QuerySnapshot snapshot) {
        final messages = snapshot.docs.map((DocumentSnapshot document) => Message.fromJson(document)).toList();
        store.dispatch(ChatSuccessAction(messages));
      },
      onError: (Object error, StackTrace stackTrace) => store.dispatch(ChatFailureAction()),
      cancelOnError: false, // TODO : EVEN if true, no error triggered
    );
  }

  void subscribeToChatStatus(String userId, Store<AppState> store) async {
    final chats =
        await FirebaseFirestore.instance.collection(_collectionPath).where('jeuneId', isEqualTo: userId).get();
    final chatDocumentId = chats.docs.first.id;
    final chatStatusCollection = FirebaseFirestore.instance.collection(_collectionPath).doc(chatDocumentId);
    final Stream<DocumentSnapshot> chatStatusStream = chatStatusCollection.snapshots();
    _chatStatusSubscription = chatStatusStream.listen(
          (DocumentSnapshot snapshot) {
        final Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
        final unreadMessageCount = data['newConseillerMessageCount'];
        final lastConseillerReading = data['lastConseillerReading'];
        final DateTime? dateTime = lastConseillerReading != null ? (lastConseillerReading as Timestamp).toDate() : null;
        store.dispatch(ChatConseillerMessageAction(unreadMessageCount, dateTime));
      },
      onError: (Object error, StackTrace stackTrace) => print("Chat status error"),
      cancelOnError: false,
    );
  }

  unsubscribeFromMessages() {
    _messagesSubscription?.cancel();
  }

  void unsubscribeFromChatStatus() {
    _chatStatusSubscription?.cancel();
  }

  sendMessage(String userId, String message) async {
    final messageCreationDate = FieldValue.serverTimestamp();
    final chats =
    await FirebaseFirestore.instance.collection(_collectionPath).where('jeuneId', isEqualTo: userId).get();
    final chatDocumentId = chats.docs.first.id;
    final messageCollection = FirebaseFirestore.instance.collection(_collectionPath).doc(chatDocumentId).collection('messages');
    final chatStatusCollection = FirebaseFirestore.instance.collection(_collectionPath).doc(chatDocumentId);

    messageCollection
        .add({
          'content': message,
          'sentBy': "jeune",
          'creationDate': messageCreationDate,
        })
        .then((value) => print("New message sent $message"))
        .catchError((error) => print("Failed to send message: $error"));

    chatStatusCollection
        .update({
          'lastMessageContent': message,
          'lastMessageSentBy': "jeune",
          'lastMessageSentAt': messageCreationDate,
          'seenByConseiller': false,
        })
        .then((value) => print("Chat status updated"))
        .catchError((error) => print("Failed to update chat status: $error"));
  }

  setLastMessageSeen(String userId) async {
    final seenByJeuneAt = FieldValue.serverTimestamp();
    final chats =
        await FirebaseFirestore.instance.collection(_collectionPath).where('jeuneId', isEqualTo: userId).get();
    final chatDocumentId = chats.docs.first.id;
    final chatStatusCollection = FirebaseFirestore.instance.collection(_collectionPath).doc(chatDocumentId);
    chatStatusCollection
        .update({
          'newConseillerMessageCount': 0,
          'lastJeuneReading': seenByJeuneAt,
        })
        .then((value) => print("Last message seen updated"))
        .catchError((error) => print("Failed to update last message seen: $error"));
  }

}
