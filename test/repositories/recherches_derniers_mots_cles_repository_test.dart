import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/recherches_derniers_mots_cles_repository.dart';

import '../doubles/spies.dart';

void main() {
  late SharedPreferencesSpy prefs;
  late RecherchesDerniersMotsClesRepository repository;

  setUp(() {
    prefs = SharedPreferencesSpy();
    repository = RecherchesDerniersMotsClesRepository(prefs);
  });

  group('DerniersMotsClesRepository', () {
    group('getDerniersMotsCles', () {
      test('should return empty list when no data', () async {
        // When
        final result = await repository.getDerniersMotsCles();

        // Then
        expect(result, []);
      });

      test('should return derniers mots cles', () async {
        // Given
        prefs.write(key: RecherchesDerniersMotsClesRepository.derniersMotsClesKey, value: '["Boulanger", "Chevalier"]');

        // When
        final result = await repository.getDerniersMotsCles();

        // Then
        expect(result, ['Boulanger', 'Chevalier']);
      });
    });

    group('saveDernierMotsCles', () {
      test('should save derniers mots cles', () async {
        // When
        await repository.saveDernierMotsCles(["Chercheur d'Or"]);

        // Then
        final result = await repository.getDerniersMotsCles();
        expect(result, ["Chercheur d'Or"]);
      });
    });
  });
}
