import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pass_emploi_app/models/message.dart';

class ChatRepository {
  final firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? _subscription;

  subscribeToMessages(String userId) async {
    unsubscribeToMessages();
    // TODO Loading ???

    // TODO Use withConverter (https://firebase.flutter.dev/docs/firestore/usage)
    final chats = await firestore.collection('chat').where('jeuneId', isEqualTo: userId).get();
    final Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('chat')
        .doc(chats.docs.first.id)
        .collection('messages')
        .orderBy('creationDate')
        .snapshots();

    _subscription = stream.listen((QuerySnapshot snapshot) {
      final messages = snapshot.docs.map((DocumentSnapshot document) => Message.fromJson(document)).toList();

      // TODO success
    }, onDone: () {
      // TODO ???
    }, onError: (Object error, StackTrace stackTrace) {
      // TODO ???
    });
  }

  unsubscribeToMessages() {
    _subscription?.cancel();
  }
}
