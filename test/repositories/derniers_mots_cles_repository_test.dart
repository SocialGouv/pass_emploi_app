import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/derniers_mots_cles_repository.dart';

import '../doubles/spies.dart';

void main() {
  late SharedPreferencesSpy prefs;
  late DerniersMotsClesRepository repository;

  setUp(() {
    prefs = SharedPreferencesSpy();
    repository = DerniersMotsClesRepository(prefs);
  });

  group('DerniersMotsClesRepository', () {
    test('should return empty list when no data', () async {
      // When
      final result = await repository.getDerniersMotsCles();

      // Then
      expect(result, []);
    });

    test('should return derniers mots cles', () async {
      // Given
      prefs.write(key: DerniersMotsClesRepository.derniersMotsClesKey, value: '["Boulanger", "Chevalier"]');

      // When
      final result = await repository.getDerniersMotsCles();

      // Then
      expect(result, ['Boulanger', 'Chevalier']);
    });
  });
}
