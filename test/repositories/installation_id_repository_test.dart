import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/installation_id_repository.dart';

import '../doubles/spies.dart';

void main() {
  late InstallationIdRepository repository;

  setUp(() {
    repository = InstallationIdRepository(FlutterSecureStorageSpy());
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

  test('getInstallationId should always return same value even if called in parallel', () async {
    // Given
    late List<String> installationIds;

    // When
    await Future.wait([
      repository.getInstallationId(),
      repository.getInstallationId(),
      repository.getInstallationId(),
    ]).then((results) => installationIds = results);

    // Then
    expect(installationIds[0], installationIds[1]);
    expect(installationIds[1], installationIds[2]);
  });
}
