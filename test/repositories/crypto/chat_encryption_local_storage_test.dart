import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_encryption_local_storage.dart';

import '../../doubles/spies.dart';

void main() {
  const randomChatKey = "7x!A%C*F-JaNdRgUkXp2s5v8y/B?E(G+";
  late ChatEncryptionLocalStorage cryptoStorage;

  setUp(() {
    cryptoStorage = ChatEncryptionLocalStorage(storage: SharedPreferencesSpy());
  });

  group('integration test should work whatever user ID is', () {
    void assertIntegrationTestWithUserId(String userId) {
      test(userId, () async {
        // Given
        await cryptoStorage.saveChatEncryptionKey(randomChatKey, userId);

        // When
        final result = await cryptoStorage.getChatEncryptionKey(userId);

        // Then
        expect(result, randomChatKey);
      });
    }

    assertIntegrationTestWithUserId('');
    assertIntegrationTestWithUserId('1234');
    assertIntegrationTestWithUserId('12345678901234567890');
    assertIntegrationTestWithUserId('1234567890123456');
  });

  test('should return empty string if no key', () async {
    expect(await cryptoStorage.getChatEncryptionKey(''), isEmpty);
  });
}
