import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/chat/cvm_message.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_event_factory.dart';

void main() {
  final factory = CvmEventFactory(cvmAttachmentUrl: 'https://cvm.fr/download/');

  group('fromJson', () {
    test('when type is message should return CvmMessageEvent', () {
      // Given
      final dynamic json = {
        'id': 'id',
        'type': 'message',
        'isFromUser': true,
        'message': 'message',
        'date': DateTime(2024, 1, 1).millisecondsSinceEpoch,
      };

      // When
      final result = factory.fromJson(json);

      // Then
      expect(
        result,
        CvmTextMessage(
          id: 'id',
          sentBy: Sender.jeune,
          content: 'message',
          date: DateTime(2024, 1, 1),
        ),
      );
    });

    test('when type is file and file info is an MXC url (Android) should return CvmFileEvent with properly built URL',
        () {
      // Given
      final dynamic json = {
        'id': 'id',
        'type': 'file',
        'isFromUser': false,
        'message': 'message',
        'fileInfo': 'mxc://matrix.org/id-file',
        'date': DateTime(2024, 1, 1).millisecondsSinceEpoch,
      };

      // When
      final result = factory.fromJson(json);

      // Then
      expect(
        result,
        CvmFileMessage(
          id: 'id',
          sentBy: Sender.conseiller,
          content: 'message',
          url: 'https://cvm.fr/download/id-file',
          fileId: 'id-file',
          date: DateTime(2024, 1, 1),
        ),
      );
    });

    test('when type is file and file info is an attachment ID (iOS) should return CvmFileEvent with properly built URL',
        () {
      // Given
      final dynamic json = {
        'id': 'id',
        'type': 'file',
        'isFromUser': false,
        'message': 'message',
        'fileInfo': 'id-file',
        'date': DateTime(2024, 1, 1).millisecondsSinceEpoch,
      };

      // When
      final result = factory.fromJson(json);

      // Then
      expect(
        result,
        CvmFileMessage(
          id: 'id',
          sentBy: Sender.conseiller,
          content: 'message',
          url: 'https://cvm.fr/download/id-file',
          fileId: 'id-file',
          date: DateTime(2024, 1, 1),
        ),
      );
    });

    test('when type is image should return CvmFileEvent', () {
      // Given
      final dynamic json = {
        'id': 'id',
        'type': 'image',
        'isFromUser': false,
        'message': 'message',
        'fileInfo': 'mxc://matrix.org/id-file',
        'date': DateTime(2024, 1, 1).millisecondsSinceEpoch,
      };

      // When
      final result = factory.fromJson(json);

      // Then
      expect(
        result,
        CvmFileMessage(
          id: 'id',
          sentBy: Sender.conseiller,
          content: 'message',
          url: 'https://cvm.fr/download/id-file',
          fileId: 'id-file',
          date: DateTime(2024, 1, 1),
        ),
      );
    });

    test('when type is unknown should return unknown event until it is handled', () {
      // Given
      final dynamic json = {
        'id': 'id',
        'type': 'unknown',
        'date': DateTime(2024, 1, 1).millisecondsSinceEpoch,
      };

      // When
      final result = factory.fromJson(json);

      // Then
      expect(
        result,
        CvmUnknownMessage(
          id: 'id',
          date: DateTime(2024, 1, 1),
        ),
      );
    });

    test('when type is typing should return null until it is handled', () {
      // Given
      final dynamic json = {
        'id': 'id',
        'type': 'typing',
      };

      // When
      final result = factory.fromJson(json);

      // Then
      expect(result, isNull);
    });

    test('when type is read should return null until it is handled', () {
      // Given
      final dynamic json = {
        'id': 'id',
        'type': 'read',
      };

      // When
      final result = factory.fromJson(json);

      // Then
      expect(result, isNull);
    });

    test('when type is member should return null until it is handled', () {
      // Given
      final dynamic json = {
        'id': 'id',
        'type': 'member',
      };

      // When
      final result = factory.fromJson(json);

      // Then
      expect(result, isNull);
    });

    test('when error on JSON should return null', () {
      // Given
      final dynamic json = {
        'id': 'id',
        'type': 'message',
        'isFromUser': true,
        'message': 'message',
        'date': null,
      };

      // When
      final result = factory.fromJson(json);

      // Then
      expect(result, isNull);
    });
  });
}
