import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';

enum Sender { jeune, conseiller }

class Message extends Equatable {
  final String content;
  final DateTime creationDate;
  final Sender sentBy;

  Message(this.content, this.creationDate, this.sentBy);

  static Message? fromJson(dynamic json, ChatCrypto chatCrypto, Crashlytics crashlytics) {
    final creationDateValue = json['creationDate'];
    final creationDate = creationDateValue is Timestamp ? creationDateValue.toDate() : DateTime.now();
    final content = _content(json, chatCrypto, crashlytics);
    if (content == null) return null;
    return Message(
      content,
      creationDate,
      json['sentBy'] as String == 'jeune' ? Sender.jeune : Sender.conseiller,
    );
  }

  static String? _content(dynamic json, ChatCrypto chatCrypto, Crashlytics crashlytics) {
    final content = json['content'] as String;
    final iv = json['iv'] as String?;

    if (iv == null) {
      crashlytics.recordNonNetworkException("Error while reading message : iv is null", StackTrace.current);
      return null;
    }

    try {
      return chatCrypto.decrypt(EncryptedTextWithIv(iv, content));
    } catch (e, stack) {
      crashlytics.recordNonNetworkException(e, stack);
      return null;
    }
  }

  @override
  List<Object?> get props => [content, creationDate, sentBy];
}
