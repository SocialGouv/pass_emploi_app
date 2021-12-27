import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';

enum Sender { jeune, conseiller }

class Message extends Equatable {
  final String content;
  final DateTime creationDate;
  final Sender sentBy;

  Message(this.content, this.creationDate, this.sentBy);

  factory Message.fromJson(dynamic json, ChatCrypto chatCrypto) {
    final creationDateValue = json['creationDate'];
    final creationDate = creationDateValue is Timestamp ? creationDateValue.toDate() : DateTime.now();
    return Message(
      _content(chatCrypto, json),
      creationDate,
      json['sentBy'] as String == 'jeune' ? Sender.jeune : Sender.conseiller,
    );
  }

  static String _content(ChatCrypto chatCrypto, dynamic json) {
    var iv;
    try {
      iv = json['iv'];
    } catch (e) {
      debugPrint(e.toString());
      iv = null;
    }
    final content = json['content'];

    if(iv == null) {
      return content;
    } else {
      try {
        return chatCrypto.decrypt(EncryptedTextWithIv(iv, content));
      } catch(e) {
        debugPrint("decryption failed, check if key properly set");
        return "🕵️‍";
      }
    }
  }

  @override
  List<Object?> get props => [content, creationDate, sentBy];
}
