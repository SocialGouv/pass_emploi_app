import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/date_consultation_notification_repository.dart';

import '../doubles/spies.dart';

void main() {
  late FlutterSecureStorageSpy secureStorage;
  late DateConsultationNotificationRepository repository;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy(delay: Duration.zero);
    repository = DateConsultationNotificationRepository(secureStorage);
  });

  group('DateConsultationNotificationRepository', () {
    test('full integration test', () async {
      // Given
      await repository.save(DateTime.utc(2022, 1, 1));

      // When
      final result = await repository.get();

      // Then
      expect(result, equals(DateTime.utc(2022, 1, 1)));
    });
  });
}
