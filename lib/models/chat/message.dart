import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';
import 'package:pass_emploi_app/repositories/rendezvous/json_rendezvous.dart';
import 'package:uuid/uuid.dart';

enum MessageType {
  message,
  nouveauConseiller,
  nouveauConseillerTemporaire,
  messagePj,
  localImagePj,
  localFilePj,
  offre,
  event,
  evenementEmploi,
  inconnu,
  sessionMilo,
}

enum OffreType { emploi, alternance, immersion, civique, inconnu }

enum MessageSendingStatus { sent, sending, failed }

enum MessageContentStatus {
  content,
  deleted,
  edited;

  String get toJson => switch (this) {
        MessageContentStatus.content => "content",
        MessageContentStatus.deleted => "deleted",
        MessageContentStatus.edited => "edited",
      };
}

class Message extends Equatable {
  final String id;
  final String? iv;
  final String content;
  final DateTime creationDate;
  final Sender sentBy;
  final MessageType type;
  final List<PieceJointe> pieceJointes;
  final String? localPieceJointePath;
  final Offre? offre;
  final Event? event;
  final ChatEvenementEmploi? evenementEmploi;
  final ChatSessionMilo? sessionMilo;
  final MessageSendingStatus sendingStatus;
  final MessageContentStatus contentStatus;

  Message({
    required this.id,
    this.iv,
    required this.content,
    required this.creationDate,
    required this.sentBy,
    required this.type,
    required this.sendingStatus,
    required this.contentStatus,
    required this.pieceJointes,
    this.localPieceJointePath,
    this.offre,
    this.event,
    this.evenementEmploi,
    this.sessionMilo,
  });

  factory Message.fromText(String text) {
    return Message(
      id: Uuid().v1(),
      content: text,
      creationDate: DateTime.now(),
      sentBy: Sender.jeune,
      type: MessageType.message,
      sendingStatus: MessageSendingStatus.sending,
      contentStatus: MessageContentStatus.content,
      pieceJointes: [],
    );
  }

  factory Message.fromImage(String imagePath) {
    return Message.fromAttachment(imagePath, MessageType.localImagePj);
  }

  factory Message.fromFile(String filePath) {
    return Message.fromAttachment(filePath, MessageType.localFilePj);
  }

  factory Message.fromAttachment(String attachmentPath, MessageType type) {
    return Message(
      id: Uuid().v1(),
      content: "",
      creationDate: DateTime.now(),
      sentBy: Sender.jeune,
      type: MessageType.localFilePj,
      sendingStatus: MessageSendingStatus.sending,
      contentStatus: MessageContentStatus.content,
      pieceJointes: [],
      localPieceJointePath: attachmentPath,
    );
  }

  Message copyWith({
    String? id,
    String? iv,
    String? content,
    DateTime? creationDate,
    Sender? sentBy,
    MessageType? type,
    List<PieceJointe>? pieceJointes,
    String? localPieceJointePath,
    Offre? offre,
    Event? event,
    ChatEvenementEmploi? evenementEmploi,
    ChatSessionMilo? sessionMilo,
    MessageSendingStatus? sendingStatus,
    MessageContentStatus? contentStatus,
  }) {
    return Message(
      id: id ?? this.id,
      iv: iv ?? this.iv,
      content: content ?? this.content,
      creationDate: creationDate ?? this.creationDate,
      sentBy: sentBy ?? this.sentBy,
      type: type ?? this.type,
      sendingStatus: sendingStatus ?? this.sendingStatus,
      contentStatus: contentStatus ?? this.contentStatus,
      pieceJointes: pieceJointes ?? this.pieceJointes,
      localPieceJointePath: localPieceJointePath ?? this.localPieceJointePath,
      offre: offre ?? this.offre,
      event: event ?? this.event,
      evenementEmploi: evenementEmploi ?? this.evenementEmploi,
      sessionMilo: sessionMilo ?? this.sessionMilo,
    );
  }

  static Message? fromJson(String id, dynamic json, ChatCrypto chatCrypto, Crashlytics crashlytics) {
    final creationDateValue = json['creationDate'];
    final creationDate = creationDateValue is Timestamp ? creationDateValue.toDate() : DateTime.now();
    final content = _content(json, chatCrypto, crashlytics);
    if (content == null) return null;
    return Message(
      id: id,
      iv: json['iv'] as String,
      content: content,
      creationDate: creationDate,
      sentBy: json['sentBy'] as String == 'jeune' ? Sender.jeune : Sender.conseiller,
      type: _type(json),
      sendingStatus: MessageSendingStatus.sent,
      contentStatus: _contentStatus(json),
      pieceJointes: _pieceJointes(json, chatCrypto, crashlytics),
      offre: _offre(json),
      event: _event(json),
      evenementEmploi: _evenementEmploi(json),
      sessionMilo: _sessionMilo(json),
    );
  }

  static MessageContentStatus _contentStatus(dynamic json) {
    final contentStatus = json['status'] as String?;
    return switch (contentStatus) {
      "deleted" => MessageContentStatus.deleted,
      "edited" => MessageContentStatus.edited,
      _ => MessageContentStatus.content,
    };
  }

  static Offre? _offre(dynamic json) {
    final offreJson = json["offre"];
    if (offreJson == null) return null;
    return Offre.fromJson(offreJson);
  }

  static Event? _event(dynamic json) {
    final eventJson = json["evenement"];
    if (eventJson == null) return null;
    return Event.fromJson(eventJson);
  }

  static ChatEvenementEmploi? _evenementEmploi(dynamic json) {
    final evenementEmploiJson = json["evenementEmploi"];
    if (evenementEmploiJson == null) return null;
    return ChatEvenementEmploi.fromJson(evenementEmploiJson);
  }

  static ChatSessionMilo? _sessionMilo(dynamic json) {
    final sessionMiloJson = json["sessionMilo"];
    if (sessionMiloJson == null) return null;
    return ChatSessionMilo.fromJson(sessionMiloJson);
  }

  static List<PieceJointe> _pieceJointes(dynamic json, ChatCrypto chatCrypto, Crashlytics crashlytics) {
    final piecesJointes = json["piecesJointes"] as List?;
    final iv = json['iv'] as String?;
    if (piecesJointes == null) return [];
    return piecesJointes
        .map((e) => PieceJointe.fromEncryptedJson(e, chatCrypto, crashlytics, iv))
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
        case "MESSAGE_EVENEMENT":
          return MessageType.event;
        case "MESSAGE_EVENEMENT_EMPLOI":
          return MessageType.evenementEmploi;
        case "MESSAGE_SESSION_MILO":
          return MessageType.sessionMilo;
        default:
          return MessageType.inconnu;
      }
    } catch (e) {
      return MessageType.message;
    }
  }

  @override
  List<Object?> get props =>
      [id, content, creationDate, sentBy, type, pieceJointes, localPieceJointePath, offre, event, evenementEmploi];
}

extension DecryptString on String {
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

  static PieceJointe? fromEncryptedJson(dynamic json, ChatCrypto chatCrypto, Crashlytics crashlytics, String? iv) {
    final id = json["id"] as String;
    final encryptedNom = json["nom"] as String;
    final nom = encryptedNom.decrypt(chatCrypto, crashlytics, iv);
    if (nom == null) return null;
    return PieceJointe(id, nom);
  }

  static PieceJointe fromJson(dynamic json) {
    final id = json["id"] as String;
    final nom = json["nom"] as String;
    return PieceJointe(id, nom);
  }
}

class Event extends Equatable {
  final String id;
  final RendezvousTypeCode type;
  final String titre;

  Event({required this.id, required this.type, required this.titre});

  @override
  List<Object?> get props => [id, titre, type];

  static Event? fromJson(dynamic json) {
    final id = json['id'] as String?;
    final titre = json['titre'] as String?;
    final type = parseRendezvousTypeCode(json['type'] as String? ?? "");
    if (id == null || titre == null) return null;
    return Event(id: id, titre: titre, type: type);
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
      return _defaultForRetrocompatibility();
    }
  }
}

class ChatEvenementEmploi extends Equatable {
  final String id;
  final String titre;
  final String url;

  ChatEvenementEmploi(this.id, this.titre, this.url);

  static ChatEvenementEmploi? fromJson(dynamic json) {
    final id = json['id'] as String?;
    final titre = json['titre'] as String?;
    final url = json['url'] as String?;
    if (id == null || titre == null || url == null) return null;
    return ChatEvenementEmploi(id, titre, url);
  }

  @override
  List<Object?> get props => [id, titre, url];
}

class ChatSessionMilo extends Equatable {
  final String id;
  final String titre;

  ChatSessionMilo(this.id, this.titre);

  static ChatSessionMilo? fromJson(dynamic json) {
    final id = json['id'] as String?;
    final titre = json['titre'] as String?;
    if (id == null || titre == null) return null;
    return ChatSessionMilo(id, titre);
  }

  @override
  List<Object?> get props => [id, titre];
}

OffreType _defaultForRetrocompatibility() => OffreType.emploi;
