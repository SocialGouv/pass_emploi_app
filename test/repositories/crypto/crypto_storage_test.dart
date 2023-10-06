import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/repositories/crypto/crypto_storage.dart';

void main() {
  late MockFlutterSecureStorage storage;
  late CryptoStorage cryptoStorage;

  setUp(() {
    storage = MockFlutterSecureStorage();
    cryptoStorage = CryptoStorage(storage: storage);
  });

  group('CryptoStorage', () {
    const dummyKey = "7x!A%C*F-JaNdRgUkXp2s5v8y/B?E(G+";
    const userId = "userId";

    group('saveKey', () {
      test('should save encrypted key', () async {
        // Given
        storage.withAnyWrite();

        // When
        await cryptoStorage.saveKey(dummyKey, userId);

        // Then
        verify(() => storage.write(
            key: CryptoStorage.storageKey, value: any(named: "value", that: isDifferentFrom(dummyKey)))).called(1);
      });
    });
    group('getKey', () {
      test('should return decrypted key', () async {
        // Given
        const encryptedB64 = "4oZpZ0aQjw881Gb52bWUtcWROO9140sWYBLrjVYnYJxv3xXxisnf4jbnqiSeM4ap";
        storage.withRead(encryptedB64);

        // When
        final key = await cryptoStorage.getKey(userId);

        // Then
        expect(key, dummyKey);
      });

      test('should return empty string if no key', () async {
        // Given
        storage.withRead(null);

        // When
        final key = await cryptoStorage.getKey(userId);

        // Then
        expect(key, "");
      });
    });
  });
}

Matcher isDifferentFrom(String value) => isNot(equals(value));

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {
  void withAnyWrite() {
    when(() => write(key: any(named: "key"), value: any(named: "value"))).thenAnswer((_) async {});
  }

  void withRead(String? value) {
    when(() => read(key: any(named: "key"))).thenAnswer((_) async => value);
  }
}
