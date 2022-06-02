import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';

enum Sender { jeune, conseiller }

enum MessageType { message, nouveauConseiller, messagePj, inconnu }

class Message extends Equatable {
  final String content;
  final DateTime creationDate;
  final Sender sentBy;
  final MessageType type;
  final List<PieceJointe> pieceJointes;

  Message(this.content, this.creationDate, this.sentBy, this.type, this.pieceJointes);

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
      _pieceJointes(json),
    );
  }

  static List<PieceJointe> _pieceJointes(dynamic json) {
    final piecesJointes = json["piecesJointes"] as List?;
    if (piecesJointes == null) return [];
    return piecesJointes.map((e) => PieceJointe.fromJson(e)).toList();
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
    // We MUST try-catch the retrieval of type attribute.
    // Because Firebase object throws a StateError when attempting to get an absent value.
    try {
      final type = json['type'] as String;
      switch (type) {
        case "MESSAGE":
          return MessageType.message;
        case "NOUVEAU_CONSEILLER":
          return MessageType.nouveauConseiller;
        case "MESSAGE_PJ":
          return MessageType.messagePj;
        default:
          return MessageType.inconnu;
      }
    } catch (e) {
      return MessageType.message;
    }
  }

  @override
  List<Object?> get props => [content, creationDate, sentBy, type, pieceJointes];
}

class PieceJointe extends Equatable {
  final String id;
  final String nom;

  PieceJointe(this.id, this.nom);

  @override
  List<Object?> get props => [id, nom];

  static PieceJointe fromJson(json) {
    final id = json["id"] as String;
    final nom = json["nom"] as String;
    return PieceJointe(id, nom);
  }
}
