import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_state.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';
import 'package:pass_emploi_app/presentation/suggestions/suggestion_alerte_location_form_view_model.dart';
import 'package:pass_emploi_app/presentation/suggestions/suggestion_recherche_card_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group('SuggestionAlerteLocationFormViewModel', () {
    test('should create with offre emploi', () {
      // Given
      final suggestionViewModel = suggestionDiagorienteViewModelOfType(OffreType.emploi);

      // When
      final viewModel = SuggestionAlerteLocationFormViewModel.create(suggestionViewModel);

      // Then
      expect(viewModel.hint.contains("emploi"), true);
      expect(viewModel.villesOnly, false);
    });

    test('should create with offre immersion', () {
      // Given
      final suggestionViewModel = suggestionDiagorienteViewModelOfType(OffreType.immersion);

      // When
      final viewModel = SuggestionAlerteLocationFormViewModel.create(suggestionViewModel);

      // Then
      expect(viewModel.hint.contains("immersion"), true);
      expect(viewModel.villesOnly, true);
    });

    test('should throw with other types', () {
      // Given
      final suggestionViewModel = suggestionDiagorienteViewModelOfType(OffreType.serviceCivique);

      // When
      SuggestionAlerteLocationFormViewModel action() =>
          SuggestionAlerteLocationFormViewModel.create(suggestionViewModel);

      // Then
      expect(action, throwsException);
    });
  });
}

SuggestionRechercheCardViewModel suggestionDiagorienteViewModelOfType(OffreType type) {
  final suggestion = suggestionPlombier().copyWith(id: 'ID', source: SuggestionSource.diagoriente, type: type);
  final store = givenState() //
      .copyWith(suggestionsRechercheState: SuggestionsRechercheSuccessState([suggestion]))
      .store();

  final viewModel = SuggestionRechercheCardViewModel.create(store, 'ID');
  return viewModel!;
}
