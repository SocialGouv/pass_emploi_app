import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/offre_dto.dart';
import 'package:pass_emploi_app/models/offre_suivie.dart';
import 'package:pass_emploi_app/repositories/offres_suivies_repository.dart';

import '../doubles/fixtures.dart';
import '../doubles/spies.dart';

void main() {
  late FlutterSecureStorageSpy secureStorage;
  late OffresSuiviesRepository repository;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy(delay: Duration.zero);
    repository = OffresSuiviesRepository(secureStorage);
  });

  final OffreSuivie offreSuivie1 = OffreSuivie(
    offreDto: OffreEmploiDto(mockOffreEmploi(id: "offre1")),
    dateConsultation: DateTime(2025),
  );

  final OffreSuivie offreSuivie2 = OffreSuivie(
    offreDto: OffreEmploiDto(mockOffreEmploi(id: "offre2")),
    dateConsultation: DateTime(2025),
  );

  test('set and get', () async {
    // Given
    final setResult1 = await repository.set(offreSuivie1);
    final setResult2 = await repository.set(offreSuivie1);
    final setResult3 = await repository.set(offreSuivie2);

    // When
    final result = await repository.get();

    // Then
    expect(
      setResult1,
      equals([offreSuivie1]),
    );
    expect(
      setResult2,
      equals([offreSuivie1]),
    );
    expect(
      setResult3,
      equals([offreSuivie1, offreSuivie2]),
    );
    expect(
      result,
      equals([offreSuivie1, offreSuivie2]),
    );
  });

  test('delete', () async {
    // Given
    await repository.set(offreSuivie1);
    await repository.set(offreSuivie2);

    // When
    final deleteResult = await repository.delete(offreSuivie1);
    final result = await repository.get();

    // Then
    expect(
      deleteResult,
      equals([offreSuivie2]),
    );

    expect(
      result,
      equals([offreSuivie2]),
    );
  });

  test('should keep a maxium of 20 values', () async {
    // Given
    for (var i = 0; i <= 21; i++) {
      await repository.set(OffreSuivie(
        offreDto: OffreEmploiDto(mockOffreEmploi(id: "offre$i")),
        dateConsultation: DateTime(2025),
      ));
    }

    // When
    final result = await repository.get();

    // Then
    expect(result[0].offreDto, equals(OffreEmploiDto(mockOffreEmploi(id: "offre2"))));
    expect(result[19].offreDto, equals(OffreEmploiDto(mockOffreEmploi(id: "offre21"))));
  });
}
