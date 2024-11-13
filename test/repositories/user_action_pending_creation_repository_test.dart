import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/user_action_pending_creation_repository.dart';

import '../doubles/fixtures.dart';
import '../doubles/spies.dart';

void main() {
  late FlutterSecureStorageSpy secureStorage;
  late UserActionPendingCreationRepository repository;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    repository = UserActionPendingCreationRepository(secureStorage);
  });

  test('Integration test', () async {
    // Given
    final request1 = mockUserActionCreateRequest('request1');
    final request2 = mockUserActionCreateRequest('request2');
    await repository.save(request1);
    await repository.save(request2);

    // When
    final pendingCreations = await repository.load();

    // Then
    expect(pendingCreations, isNotEmpty);
    expect(pendingCreations[0], request1);
    expect(pendingCreations[1], request2);
  });

  test('save should return pending action creations count updated', () async {
    // Given
    final request1 = mockUserActionCreateRequest('request1');
    final request2 = mockUserActionCreateRequest('request2');

    // When
    final count1 = await repository.save(request1);
    final count2 = await repository.save(request2);

    // Then
    expect(count1, 1);
    expect(count2, 2);
  });

  test('delete', () async {
    // Given
    final request1 = mockUserActionCreateRequest('request1');
    final request2 = mockUserActionCreateRequest('request2');
    await repository.save(request1);
    await repository.save(request2);

    // When
    await repository.delete(request1);
    final pendingCreations = await repository.load();

    // Then
    expect(pendingCreations.length, 1);
    expect(pendingCreations.first, request2);
  });

  test('getPendingActionCount', () async {
    // Given
    await repository.save(mockUserActionCreateRequest());

    // When
    final count = await repository.getPendingActionCount();

    // Then
    expect(count, 1);
  });
}
