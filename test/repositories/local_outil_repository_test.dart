import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/repositories/local_outil_repository.dart';

void main() {
  group('LocalOutilRepository', () {
    test('should return a list of outils when brand is BRSA', () {
      // Given
      final localOutilRepository = LocalOutilRepository();
      // When
      final outilsBrsa = localOutilRepository.getOutils(Brand.brsa);
      // Then
      expect(outilsBrsa.length, 5);
      expect(outilsBrsa[0].title, "J'accède à mes aides");
      expect(outilsBrsa[1].title, "Je m’engage bénévolement");
      expect(outilsBrsa[2].title, "Emploi-Store");
      expect(outilsBrsa[3].title, "Je postule pour un job dans une entreprise solidaire");
      expect(outilsBrsa[4].title, "La bonne boîte");
    });

    test('should return a list of outils when brand is CEJ', () {
      // Given
      final localOutilRepository = LocalOutilRepository();
      // When
      final outilsCej = localOutilRepository.getOutils(Brand.cej);
      // Then
      expect(outilsCej.length, 10);
      expect(outilsCej[0].title, "Je m’engage bénévolement");
      expect(outilsCej[1].title, "Diagoriente");
      expect(outilsCej[2].title, "J'accède à mes aides");
      expect(outilsCej[3].title, "Trouver un mentor avec 1 jeune, 1 mentor");
      expect(outilsCej[4].title, "Trouver une formation");
      expect(outilsCej[5].title, "Événements de recrutement");
      expect(outilsCej[6].title, "Emploi-Store");
      expect(outilsCej[7].title, "Je postule pour un job dans une entreprise solidaire");
      expect(outilsCej[8].title, "La bonne boîte");
      expect(outilsCej[9].title, "Alternance avec 1 jeune, 1 solution");
    });
  });
}
