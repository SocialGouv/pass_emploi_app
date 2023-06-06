import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/presentation/suggestions/suggestion_alerte_location_form_view_model.dart';

void main() {
  group('SuggestionAlerteLocationFormViewModel', () {
    test('should create with offre emploi', () {
      // Given
      const type = OffreType.emploi;

      // When
      final viewModel = SuggestionAlerteLocationFormViewModel.create(type);

      // Then
      expect(viewModel.hint.contains("emploi"), true);
      expect(viewModel.villesOnly, false);
    });

    test('should create with offre immersion', () {
      // Given
      const type = OffreType.immersion;

      // When
      final viewModel = SuggestionAlerteLocationFormViewModel.create(type);

      // Then
      expect(viewModel.hint.contains("immersion"), true);
      expect(viewModel.villesOnly, true);
    });

    test('should throw with other types', () {
      // Given
      const type = OffreType.serviceCivique;

      // When
      SuggestionAlerteLocationFormViewModel action() => SuggestionAlerteLocationFormViewModel.create(type);

      // Then
      expect(action, throwsException);
    });
  });
}
