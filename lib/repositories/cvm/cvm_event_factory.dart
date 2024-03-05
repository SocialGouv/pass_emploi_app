import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/cvm/cvm_event.dart';

class CvmEventFactory {
  final String cvmAttachmentUrl;
  final Crashlytics? crashlytics;

  CvmEventFactory({required this.cvmAttachmentUrl, this.crashlytics});

  CvmEvent? fromJson(dynamic json) {
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

  CvmMessageEvent _toMessageEvent(_JsonCvmEvent jsonEvent) {
    return CvmMessageEvent(
      id: jsonEvent.id!,
      isFromUser: jsonEvent.isFromUser!,
      content: jsonEvent.content!,
      date: jsonEvent.date!,
    );
  }

  CvmFileEvent _toFileEvent(_JsonCvmEvent jsonEvent) {
    return CvmFileEvent(
      id: jsonEvent.id!,
      isFromUser: jsonEvent.isFromUser!,
      content: jsonEvent.content!,
      url: _mxcToUrl(jsonEvent.fileInfo!),
      date: jsonEvent.date!,
    );
  }

  CvmUnknownEvent _toUnknownEvent(_JsonCvmEvent jsonEvent) {
    return CvmUnknownEvent(
      id: jsonEvent.id!,
      date: jsonEvent.date!,
    );
  }

  String _mxcToUrl(String fileInfo) => cvmAttachmentUrl + fileInfo.split('/').last;
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
  final String? content;
  final String? fileInfo;

  _JsonCvmEvent({
    required this.type,
    required this.id,
    required this.date,
    required this.isFromUser,
    required this.content,
    required this.fileInfo,
  });

  factory _JsonCvmEvent.fromJson(dynamic json) {
    return _JsonCvmEvent(
      type: _CvmEventType.fromValue(json['type'] as String),
      id: json['id'] as String?,
      date: json['date'] is int ? DateTime.fromMillisecondsSinceEpoch(json['date'] as int) : null,
      isFromUser: json['isFromUser'] as bool?,
      content: json['message'] as String?,
      fileInfo: json['fileInfo'] as String?,
    );
  }
}
