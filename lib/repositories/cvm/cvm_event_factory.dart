import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/chat/cvm_message.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';

class CvmEventFactory {
  final String cvmAttachmentUrl;
  final Crashlytics? crashlytics;

  CvmEventFactory({required this.cvmAttachmentUrl, this.crashlytics});

  CvmMessage? fromJson(dynamic json) {
    try {
      final jsonEvent = _JsonCvmEvent.fromJson(json);
      return switch (jsonEvent.type) {
        _CvmEventType.message => _toMessageEvent(jsonEvent),
        _CvmEventType.file => _toFileEvent(jsonEvent),
        _CvmEventType.image => _toFileEvent(jsonEvent),
        _CvmEventType.unknown => _toUnknownEvent(jsonEvent),
        _ => null,
      };
    } catch (e) {
      crashlytics?.log("CvmEventFactory.fromJson error on following json: $json");
      crashlytics?.recordCvmException(e);
      return null;
    }
  }

  CvmTextMessage _toMessageEvent(_JsonCvmEvent jsonEvent) {
    return CvmTextMessage(
      id: jsonEvent.id!,
      sentBy: jsonEvent.isFromUser! ? Sender.jeune : Sender.conseiller,
      content: jsonEvent.content!,
      date: jsonEvent.date!,
      readByConseiller: jsonEvent.readByConseiller!,
    );
  }

  CvmFileMessage _toFileEvent(_JsonCvmEvent jsonEvent) {
    return CvmFileMessage(
      id: jsonEvent.id!,
      sentBy: jsonEvent.isFromUser! ? Sender.jeune : Sender.conseiller,
      fileName: jsonEvent.content!,
      url: _url(jsonEvent.fileInfo!),
      fileId: _fileId(jsonEvent.fileInfo!),
      date: jsonEvent.date!,
    );
  }

  CvmUnknownMessage _toUnknownEvent(_JsonCvmEvent jsonEvent) {
    return CvmUnknownMessage(
      id: jsonEvent.id!,
      date: jsonEvent.date!,
    );
  }

  String _fileId(String fileInfo) => fileInfo.replaceFirst('mxc://', '');

  String _url(String fileInfo) => cvmAttachmentUrl + _fileId(fileInfo);
}

enum _CvmEventType {
  message('message'),
  file('file'),
  image('image'),
  typing('typing'),
  read('read'),
  member('member'),
  unknown('unknown');

  final String value;

  const _CvmEventType(this.value);

  static _CvmEventType fromValue(String value) {
    return _CvmEventType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => unknown,
    );
  }
}

class _JsonCvmEvent {
  final _CvmEventType type;
  final String? id;
  final DateTime? date;
  final bool? isFromUser;
  final bool? readByConseiller;
  final String? content;
  final String? fileInfo;

  _JsonCvmEvent({
    required this.type,
    required this.id,
    required this.date,
    required this.isFromUser,
    required this.readByConseiller,
    required this.content,
    required this.fileInfo,
  });

  factory _JsonCvmEvent.fromJson(dynamic json) {
    return _JsonCvmEvent(
      type: _CvmEventType.fromValue(json['type'] as String),
      id: json['id'] as String?,
      date: json['date'] is int ? DateTime.fromMillisecondsSinceEpoch(json['date'] as int) : null,
      isFromUser: json['isFromUser'] as bool?,
      readByConseiller: json['readByConseiller'] as bool?,
      content: json['message'] as String?,
      fileInfo: json['fileInfo'] as String?,
    );
  }
}
