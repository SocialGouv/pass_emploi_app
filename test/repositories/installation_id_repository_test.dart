import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/installation_id_repository.dart';

import '../doubles/spies.dart';

void main() {
  late InstallationIdRepository repository;

  setUp(() {
    repository = InstallationIdRepository(SharedPreferencesSpy());
  });

  test('getInstallationId should return a UUID', () async {
    // Given
    final uuidRegex = RegExp('[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}');

    // When
    final installationId = await repository.getInstallationId();

    // Then
    expect(uuidRegex.hasMatch(installationId), isTrue);
  });

  test('getInstallationId should always return same value', () async {
    // When
    final installationId1 = await repository.getInstallationId();
    final installationId2 = await repository.getInstallationId();
    final installationId3 = await repository.getInstallationId();

    // Then
    expect(installationId1, installationId2);
    expect(installationId1, installationId3);
  });
}
