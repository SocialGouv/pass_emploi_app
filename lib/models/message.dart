import 'package:cloud_firestore/cloud_firestore.dart';

enum Sender { jeune, conseiller }

class Message {
  final String content;
  final DateTime creationDate;
  final Sender sentBy;

  Message(this.content, this.creationDate, this.sentBy);

  factory Message.fromJson(dynamic json) {
    return Message(
      json['content'] as String,
      (json['creationDate'] as Timestamp).toDate(),
      json['sentBy'] as String == 'jeune' ? Sender.jeune : Sender.conseiller,
    );
  }
}
