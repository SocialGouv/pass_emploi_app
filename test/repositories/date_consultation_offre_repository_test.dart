import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/repositories/date_consultation_offre_repository.dart';

import '../doubles/mocks.dart';

void main() {
  late MockFlutterSecureStorage mockFlutterSecureStorage;
  late DateConsultationOffreRepository repository;

  setUp(() {
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    repository = DateConsultationOffreRepository(mockFlutterSecureStorage);
  });

  group('DateConsultationOffreRepository', () {
    group('get', () {
      test('should retorun empty map when key is not registered', () async {
        // Given
        mockFlutterSecureStorage.withAnyRead(null);

        // When
        final result = await repository.get();

        // Then
        expect(result, equals({}));
      });

      test('should return map when key is registered', () async {
        // Given
        mockFlutterSecureStorage.withAnyRead('{"offreId": "2022-01-01T00:00:00.000Z"}');

        // When
        final result = await repository.get();

        // Then
        expect(result, equals({"offreId": DateTime.utc(2022, 1, 1)}));
      });
    });

    group('set', () {
      test('should add offre', () async {
        // Given
        mockFlutterSecureStorage.withAnyRead('{"offreId": "2022-01-01T00:00:00.000Z"}');

        // When
        await repository.set("offreId", DateTime.utc(2022, 1, 1));

        // Then
        verify(
          () => mockFlutterSecureStorage.write(
            key: "date_consultation_offre",
            value: '{"offreId":"2022-01-01T00:00:00.000Z"}',
          ),
        );
      });
    });
  });
}
