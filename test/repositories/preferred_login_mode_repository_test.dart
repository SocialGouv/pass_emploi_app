import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/repositories/preferred_login_mode_repository.dart';

import '../doubles/mocks.dart';

void main() {
  late MockFlutterSecureStorage mockFlutterSecureStorage;
  late PreferredLoginModeRepository repository;

  setUp(() {
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    repository = PreferredLoginModeRepository(mockFlutterSecureStorage);
  });

  group('PreferredLoginModeRepository', () {
    group('save', () {
      test('should save login mode', () async {
        // Given
        const loginMode = LoginMode.DEMO_MILO;

        // When
        await repository.save(loginMode);

        // Then
        verify(() => mockFlutterSecureStorage.write(key: 'preferredLoginMode', value: 'DEMO_MILO'));
      });
    });

    group('get', () {
      test('should return login mode', () async {
        // Given
        when(() => mockFlutterSecureStorage.read(key: 'preferredLoginMode'))
            .thenAnswer((_) => Future.value('DEMO_MILO'));

        // When
        final result = await repository.get();

        // Then
        expect(result, LoginMode.DEMO_MILO);
      });

      test('should return null if no login mode', () async {
        // Given
        when(() => mockFlutterSecureStorage.read(key: 'preferredLoginMode')).thenAnswer((_) => Future.value(null));

        // When
        final result = await repository.get();

        // Then
        expect(result, null);
      });
    });
  });
}
