import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';

enum Sender { jeune, conseiller }
enum MessageType { message, nouveauConseiller, unknown }

class Message extends Equatable {
  final String content;
  final DateTime creationDate;
  final Sender sentBy;
  final MessageType type;

  Message(this.content, this.creationDate, this.sentBy, this.type);

  static Message? fromJson(dynamic json, ChatCrypto chatCrypto, Crashlytics crashlytics) {
    final creationDateValue = json['creationDate'];
    final creationDate = creationDateValue is Timestamp ? creationDateValue.toDate() : DateTime.now();
    final content = _content(json, chatCrypto, crashlytics);
    if (content == null) return null;
    return Message(
      content,
      creationDate,
      json['sentBy'] as String == 'jeune' ? Sender.jeune : Sender.conseiller,
      _type(json),
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

  static MessageType _type(dynamic json) {
    final type = json["type"] as String?;
    switch (type) {
      case "NOUVEAU_CONSEILLER":
        return MessageType.nouveauConseiller;
      case "MESSAGE":
      case null:
        return MessageType.message;
      default:
        return MessageType.unknown;
    }
  }

  @override
  List<Object?> get props => [content, creationDate, sentBy, type];
}
