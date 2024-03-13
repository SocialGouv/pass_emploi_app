import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_last_reading_repository.dart';

import '../../doubles/spies.dart';

void main() {
  late CvmLastReadingRepository repository;

  setUp(() {
    repository = CvmLastReadingRepository(SharedPreferencesSpy());
  });

  test('integration test', () async {
    // Given
    final date = DateTime(2024, 4, 12);

    // When
    await repository.saveLastReading(date);
    final result = await repository.getLastReading();

    // Then
    expect(result, date);
  });

  test('when nothing saved', () async {
    // When
    final result = await repository.getLastReading();

    // Then
    expect(result, isNull);
  });
}
