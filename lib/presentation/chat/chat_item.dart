import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/chat/message.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';

sealed class ChatItem extends Equatable {
  final String messageId;
  final bool shouldAnimate;

  ChatItem(this.messageId, {this.shouldAnimate = false});

  @override
  List<Object?> get props => [messageId, shouldAnimate];
}

class DayItem extends ChatItem {
  final String dayLabel;

  DayItem(this.dayLabel) : super('');

  @override
  List<Object?> get props => [messageId, dayLabel];
}

class InformationItem extends ChatItem {
  final String title;
  final String description;

  InformationItem(this.title, this.description) : super('');

  @override
  List<Object?> get props => [messageId, title, description];
}

class DeletedMessageItem extends ChatItem {
  DeletedMessageItem(super.messageId, this.sender);

  final Sender sender;

  @override
  List<Object?> get props => [messageId];
}

sealed class MessageItem extends ChatItem {
  final String content;
  final String caption;
  final Color? captionColor;

  MessageItem(super.messageId, bool shouldAnimate, this.content, this.caption, this.captionColor)
      : super(shouldAnimate: shouldAnimate);

  @override
  List<Object?> get props => [
        messageId,
        content,
        caption,
        captionColor,
        shouldAnimate,
      ];
}

class TextMessageItem extends MessageItem {
  final Sender sender;

  TextMessageItem({
    required String messageId,
    required String content,
    required String caption,
    required this.sender,
    Color? captionColor,
    bool shouldAnimate = false,
  }) : super(messageId, shouldAnimate, content, caption, captionColor);

  @override
  List<Object?> get props => [messageId, content, caption, captionColor, shouldAnimate, sender];
}

abstract class PartageMessageItem extends MessageItem {
  final String idPartage;
  final String titrePartage;
  final Sender sender;

  PartageMessageItem(
    super.messageId,
    super.content,
    super.caption,
    super.captionColor,
    super.shouldAnimate,
    this.idPartage,
    this.titrePartage,
    this.sender,
  );

  @override
  List<Object?> get props =>
      [messageId, content, caption, captionColor, shouldAnimate, idPartage, titrePartage, sender];
}

class OffreMessageItem extends PartageMessageItem {
  final OffreType type;

  OffreMessageItem({
    required String messageId,
    required String content,
    required String caption,
    required Sender sender,
    required String idPartage,
    required String titrePartage,
    required this.type,
    Color? captionColor,
    bool shouldAnimate = false,
  }) : super(messageId, shouldAnimate, content, caption, captionColor, idPartage, titrePartage, sender);

  @override
  List<Object?> get props =>
      [messageId, content, caption, captionColor, shouldAnimate, sender, idPartage, titrePartage, type];
}

class EventMessageItem extends PartageMessageItem {
  EventMessageItem({
    required String messageId,
    required String content,
    required String caption,
    required Sender sender,
    required String idPartage,
    required String titrePartage,
    Color? captionColor,
    bool shouldAnimate = false,
  }) : super(messageId, shouldAnimate, content, caption, captionColor, idPartage, titrePartage, sender);

  @override
  List<Object?> get props =>
      [messageId, content, caption, captionColor, shouldAnimate, sender, idPartage, titrePartage];
}

class EvenementEmploiMessageItem extends PartageMessageItem {
  EvenementEmploiMessageItem({
    required String messageId,
    required String content,
    required String caption,
    required Sender sender,
    required String idPartage,
    required String titrePartage,
    Color? captionColor,
    bool shouldAnimate = false,
  }) : super(messageId, shouldAnimate, content, caption, captionColor, idPartage, titrePartage, sender);

  @override
  List<Object?> get props =>
      [messageId, content, caption, captionColor, shouldAnimate, sender, idPartage, titrePartage];
}

class SessionMiloMessageItem extends PartageMessageItem {
  SessionMiloMessageItem({
    required String messageId,
    required String content,
    required String caption,
    required Sender sender,
    required String idPartage,
    required String titrePartage,
    Color? captionColor,
    bool shouldAnimate = false,
  }) : super(messageId, shouldAnimate, content, caption, captionColor, idPartage, titrePartage, sender);

  @override
  List<Object?> get props =>
      [messageId, content, caption, captionColor, shouldAnimate, sender, idPartage, titrePartage];
}

class PieceJointeConseillerMessageItem extends ChatItem {
  final String pieceJointeId;
  final String message;
  final String filename;
  final String caption;
  final Color? captionColor;

  PieceJointeConseillerMessageItem({
    required String messageId,
    required this.pieceJointeId,
    required this.message,
    required this.filename,
    required this.caption,
    this.captionColor,
    bool shouldAnimate = false,
  }) : super(messageId, shouldAnimate: shouldAnimate);

  @override
  List<Object?> get props => [messageId, pieceJointeId, message, filename, caption, captionColor, shouldAnimate];
}
