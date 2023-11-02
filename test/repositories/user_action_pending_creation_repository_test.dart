import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/user_action_pending_creation_repository.dart';

import '../doubles/fixtures.dart';
import '../doubles/spies.dart';

void main() {
  late SharedPreferencesSpy preferences;
  late UserActionPendingCreationRepository repository;

  setUp(() {
    preferences = SharedPreferencesSpy();
    repository = UserActionPendingCreationRepository(preferences);
  });

  test('Integration test', () async {
    // Given
    final request1 = dummyUserActionCreateRequest('request1');
    final request2 = dummyUserActionCreateRequest('request2');
    await repository.save(request1);
    await repository.save(request2);

    // When
    final pendingCreations = await repository.load();

    // Then
    expect(pendingCreations, isNotEmpty);
    expect(pendingCreations[0], request1);
    expect(pendingCreations[1], request2);
  });

  test('delete', () async {
    // Given
    final request1 = dummyUserActionCreateRequest('request1');
    final request2 = dummyUserActionCreateRequest('request2');
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
    await repository.save(dummyUserActionCreateRequest());

    // When
    final count = await repository.getPendingActionCount();

    // Then
    expect(count, 1);
  });
}
