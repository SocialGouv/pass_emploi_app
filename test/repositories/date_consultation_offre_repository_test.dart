import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/date_consultation_offre_repository.dart';

import '../doubles/spies.dart';

void main() {
  late FlutterSecureStorageSpy secureStorage;
  late DateConsultationOffreRepository repository;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy(delay: Duration.zero);
    repository = DateConsultationOffreRepository(secureStorage);
  });

  test('full integration test', () async {
    // Given
    await repository.set("offre1", DateTime.utc(2022, 1, 1));
    await repository.set("offre2", DateTime.utc(2022, 1, 2));

    // When
    final result = await repository.get();

    // Then
    expect(
      result,
      equals({
        "offre1": DateTime.utc(2022, 1, 1),
        "offre2": DateTime.utc(2022, 1, 2),
      }),
    );
  });

  test('should just keep a maximum of 100 values, deleting oldest ones', () async {
    // Given
    for (var i = 0; i <= 101; i++) {
      await repository.set("offre-$i", DateTime.utc(2022, 1, 1).add(Duration(days: i)));
    }

    // When
    final result = await repository.get();

    // Then
    expect(result["offre-0"], isNull);
    expect(result["offre-101"], isNotNull);
  });
}
