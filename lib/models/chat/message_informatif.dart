import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/chat/message.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';

class MessageInformatif extends Equatable {
  final String message;
  final DateTime dateDebut;
  final DateTime dateFin;

  MessageInformatif({
    required this.message,
    required this.dateDebut,
    required this.dateFin,
  });

  @override
  List<Object?> get props => [
        message,
        dateDebut,
        dateFin,
      ];

  static MessageInformatif? fromJson(dynamic json, ChatCrypto chatCrypto, Crashlytics crashlytics) {
    final dateDebutValue = json['dateDebut'];
    final dateFinValue = json['dateFin'];
    final dateDebut = dateDebutValue is Timestamp ? dateDebutValue.toDate() : DateTime.now();
    final dateFin = dateFinValue is Timestamp ? dateFinValue.toDate() : DateTime.now();
    final message = _message(json, chatCrypto, crashlytics);

    if (message == null || message.isEmpty) {
      return null;
    }

    return MessageInformatif(
      message: message,
      dateDebut: dateDebut,
      dateFin: dateFin,
    );
  }

  static String? _message(dynamic json, ChatCrypto chatCrypto, Crashlytics crashlytics) {
    final content = json['message'] as String;
    final iv = json['iv'] as String?;
    return content.decrypt(chatCrypto, crashlytics, iv);
  }
}
