import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// TODO DELETE
class ChatPageOLD extends StatefulWidget {
  @override
  _ChatPageOLDState createState() => _ChatPageOLDState();
}

class _ChatPageOLDState extends State<ChatPageOLD> {
  //final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance.collection('chat').where('jeuneId', isEqualTo: '2').snapshots();
  final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
      .collection('chat')
      .doc('fR69o37z9p9n22cNtcAU')
      .collection('messages')
      .orderBy('creationDate')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Text("Loading"));
        }

        return Scaffold(
          body: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['content']),
                //subtitle: Text(data['creationDate']),
              );
            }).toList(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              CollectionReference messages =
                  FirebaseFirestore.instance.collection('chat').doc('fR69o37z9p9n22cNtcAU').collection('messages');
              messages
                  .add({'content': "Hello", 'sentBy': "jeune", 'creationDate': FieldValue.serverTimestamp()})
                  .then((value) => print("Message Added"))
                  .catchError((error) => print("Failed to add user: $error"));
            },
          ),
        );
      },
    );
  }
}
