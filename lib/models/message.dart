import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';

enum Sender { jeune, conseiller }

enum MessageType { message, nouveauConseiller, nouveauConseillerTemporaire, messagePj, offre, inconnu }

enum OffreType { emploi, alternance, immersion, civique, inconnu }

class Message extends Equatable {
  final String content;
  final DateTime creationDate;
  final Sender sentBy;
  final MessageType type;
  final List<PieceJointe> pieceJointes;
  final Offre? offre;

  Message(
    this.content,
    this.creationDate,
    this.sentBy,
    this.type,
    this.pieceJointes, [
    this.offre,
  ]);

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
      _pieceJointes(json, chatCrypto, crashlytics),
      _offre(json),
    );
  }

  static Offre? _offre(dynamic json) {
    final offreJson = json["offre"];
    if (offreJson == null) return null;
    return Offre.fromJson(offreJson);
  }

  static List<PieceJointe> _pieceJointes(dynamic json, ChatCrypto chatCrypto, Crashlytics crashlytics) {
    final piecesJointes = json["piecesJointes"] as List?;
    final iv = json['iv'] as String?;
    if (piecesJointes == null) return [];
    return piecesJointes
        .map((e) => PieceJointe.fromJson(e, chatCrypto, crashlytics, iv))
        .whereType<PieceJointe>()
        .toList();
  }

  static String? _content(dynamic json, ChatCrypto chatCrypto, Crashlytics crashlytics) {
    final content = json['content'] as String;
    final iv = json['iv'] as String?;
    return content.decrypt(chatCrypto, crashlytics, iv);
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
        case "NOUVEAU_CONSEILLER_TEMPORAIRE":
          return MessageType.nouveauConseillerTemporaire;
        case "MESSAGE_PJ":
          return MessageType.messagePj;
        case "MESSAGE_OFFRE":
          return MessageType.offre;
        default:
          return MessageType.inconnu;
      }
    } catch (e) {
      return MessageType.message;
    }
  }

  @override
  List<Object?> get props => [content, creationDate, sentBy, type, pieceJointes, offre];
}

extension _DecryptString on String {
  String? decrypt(ChatCrypto chatCrypto, Crashlytics crashlytics, String? iv) {
    if (iv == null) {
      crashlytics.recordNonNetworkException("Error while reading message : iv is null", StackTrace.current);
      return null;
    }

    try {
      return chatCrypto.decrypt(EncryptedTextWithIv(iv, this));
    } catch (e, stack) {
      crashlytics.recordNonNetworkException(e, stack);
      return null;
    }
  }
}

class PieceJointe extends Equatable {
  final String id;
  final String nom;

  PieceJointe(this.id, this.nom);

  @override
  List<Object?> get props => [id, nom];

  static PieceJointe? fromJson(dynamic json, ChatCrypto chatCrypto, Crashlytics crashlytics, String? iv) {
    final id = json["id"] as String;
    final encryptedNom = json["nom"] as String;
    final nom = encryptedNom.decrypt(chatCrypto, crashlytics, iv);
    if (nom == null) return null;
    return PieceJointe(id, nom);
  }
}

class Offre extends Equatable {
  final String id;
  final String titre;
  final OffreType type;

  Offre(this.id, this.titre, this.type);

  @override
  List<Object?> get props => [id, titre, type];

  static Offre? fromJson(dynamic json) {
    final id = json['id'] as String?;
    final titre = json['titre'] as String?;
    final type = _type(json);
    if (id == null || titre == null || type == null) return null;
    return Offre(id, titre, type);
  }

  static OffreType? _type(dynamic json) {
    try {
      final type = json['type'] as String;
      switch (type) {
        case "ALTERNANCE":
          return OffreType.alternance;
        case "EMPLOI":
          return OffreType.emploi;
        case "IMMERSION":
          return OffreType.immersion;
        case "SERVICE_CIVIQUE":
          return OffreType.civique;
        default:
          return OffreType.inconnu;
      }
    } catch (e) {
      return OffreType.inconnu;
    }
  }
}
