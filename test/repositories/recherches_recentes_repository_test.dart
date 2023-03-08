import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/recherches_recentes_repository.dart';

import '../doubles/fixtures.dart';
import '../doubles/spies.dart';
import '../utils/test_assets.dart';

void main() {
  late SharedPreferencesSpy prefs;
  late RecherchesRecentesRepository repository;

  setUp(() {
    prefs = SharedPreferencesSpy();
    repository = RecherchesRecentesRepository(prefs);
  });

  group('RecherchesRecentesRepository', () {
    group('get', () {
      test('should return empty list when no data', () async {
        // When
        final result = await repository.get();

        // Then
        expect(result, []);
      });

      test('should return saved searches when data exist', () async {
        // Given
        prefs.write(key: 'recent_searches', value: loadTestAssets("saved_search_data.json"));

        // When
        final result = await repository.get();

        // Then
        expect(result, getMockedSavedSearch());
      });
    });

    group('save', () {
      test('should save searches', () async {
        // Given
        final searches = getMockedSavedSearch();

        // When
        await repository.save(searches);

        // Then
        final result = await repository.get();
        expect(result, searches);
      });
    });
  });
}
