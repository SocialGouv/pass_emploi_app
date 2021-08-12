import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/redux/actions/chat_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

class ChatRepository {
  final firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? _subscription;
  String? _chatDocumentId;

  // TODO return stream and remove store from params
  // https://www.youtube.com/watch?v=nQBpOIHE4eE (6:23)
  // TODO unsubscribe depending on app lifecycle
  subscribeToMessages(String userId, Store<AppState> store) async {
    unsubscribeToMessages();
    store.dispatch(ChatLoadingAction());

    // TODO Use withConverter (https://firebase.flutter.dev/docs/firestore/usage)
    final chats = await firestore.collection('chat').where('jeuneId', isEqualTo: userId).get();
    _chatDocumentId = chats.docs.first.id;

    final Stream<QuerySnapshot> stream = _collection().orderBy('creationDate').snapshots();
    _subscription = stream.listen(
      (QuerySnapshot snapshot) {
        final messages = snapshot.docs.map((DocumentSnapshot document) => Message.fromJson(document)).toList();
        store.dispatch(ChatSuccessAction(messages));
      },
      onError: (Object error, StackTrace stackTrace) {
        store.dispatch(ChatFailureAction());
      },
      cancelOnError: false,
    );
  }

  unsubscribeToMessages() {
    _subscription?.cancel();
  }

  sendMessage(String message) {
    _collection()
        .add({'content': message, 'sentBy': "jeune", 'creationDate': FieldValue.serverTimestamp()})
        .then((value) => print("New message sent $message"))
        .catchError((error) => print("Failed to send message: $error"));
  }

  _collection() => FirebaseFirestore.instance.collection('chat').doc(_chatDocumentId).collection('messages');
}
