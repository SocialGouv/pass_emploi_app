import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';

// TODO-CVM add file
enum CvmEventType {
  message,
  unknown,
}

class CvmEvent extends Equatable {
  final String id;
  final CvmEventType type;
  final bool isFromUser;
  final String? message;
  final DateTime? date;

  CvmEvent({
    required this.id,
    required this.type,
    required this.isFromUser,
    required this.message,
    required this.date,
  });

  static CvmEvent? fromJson(dynamic json, [Crashlytics? crashlytics]) {
    try {
      return CvmEvent(
        id: json['id'] as String,
        type: json['type'] == 'message' ? CvmEventType.message : CvmEventType.unknown,
        isFromUser: json['isFromUser'] as bool,
        message: json['message'] as String,
        date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      );
    } catch (e) {
      crashlytics?.log("CvmMiddleware.fromJson error on following json $json");
      crashlytics?.recordCvmException(e);
      return null;
    }
  }

  @override
  List<Object?> get props => [id, type, isFromUser, message, date];
}
