import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_state.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';
import 'package:pass_emploi_app/presentation/suggestions/suggestion_recherche_card_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test("should be created with a suggestion", () {
    // Given
    final store = givenState().withSuggestionsRecherche().store();

    // When
    final viewModel = SuggestionRechercheCardViewModel.create(store, suggestionCaristeFromPoleEmploi().id);

    // Then
    expect(viewModel, isNotNull);
    expect(viewModel!.type, OffreType.emploi);
    expect(viewModel.titre, "Cariste");
    expect(viewModel.source, "Profil France Travail");
    expect(viewModel.metier, "Conduite d'engins de déplacement des charges");
    expect(viewModel.localisation, "Nord");
    expect(viewModel.withLocationForm, false);
  });

  test("should be null without a suggestion", () {
    // Given
    final store = givenState().store();

    // When
    final viewModel = SuggestionRechercheCardViewModel.create(store, "void");

    // Then
    expect(viewModel, isNull);
  });

  group('source should have proper labels', () {
    void assertLabel({required SuggestionSource? givenSource, required String? expectedLabel}) {
      test('given $givenSource should return $expectedLabel', () {
        // Given
        final suggestion = suggestionPlombier().copyWith(id: 'ID', source: givenSource);
        final store = givenState() //
            .copyWith(suggestionsRechercheState: SuggestionsRechercheSuccessState([suggestion]))
            .store();

        // When
        final viewModel = SuggestionRechercheCardViewModel.create(store, 'ID');

        // Then
        expect(viewModel?.source, expectedLabel);
      });
    }

    assertLabel(givenSource: SuggestionSource.poleEmploi, expectedLabel: 'Profil France Travail');
    assertLabel(givenSource: SuggestionSource.conseiller, expectedLabel: 'Conseiller');
    assertLabel(givenSource: null, expectedLabel: null);
  });

  test('should display location form when source is diagoriente', () {
    // Given
    final suggestion = suggestionPlombier().copyWith(id: 'ID', source: SuggestionSource.diagoriente);
    final store = givenState() //
        .copyWith(suggestionsRechercheState: SuggestionsRechercheSuccessState([suggestion]))
        .store();

    // When
    final viewModel = SuggestionRechercheCardViewModel.create(store, 'ID');

    // Then
    expect(viewModel?.source, 'Métiers favoris');
    expect(viewModel?.withLocationForm, true);
  });

  test("should dispatch accepter suggestion", () {
    // Given
    final store = givenState().withSuggestionsRecherche().spyStore();
    final viewModel = SuggestionRechercheCardViewModel.create(store, suggestionCaristeFromPoleEmploi().id);

    // When
    viewModel?.ajouterSuggestion();

    // Then
    expect(viewModel, isNotNull);
    expect(
      store.dispatchedAction,
      TraiterSuggestionRechercheRequestAction(suggestionCaristeFromPoleEmploi(), TraiterSuggestionType.accepter),
    );
  });

  test("should dispatch accepter suggestion with Location and rayon", () {
    // Given
    final store = givenState().withSuggestionsRecherche().spyStore();
    final viewModel = SuggestionRechercheCardViewModel.create(store, suggestionCaristeFromPoleEmploi().id);
    final location = mockLocation(lat: 48.830108, lon: 2.323026);
    const rayon = 10.0;

    // When
    viewModel?.ajouterSuggestion(location: location, rayon: rayon);

    // Then
    expect(viewModel, isNotNull);
    expect(
      store.dispatchedAction,
      TraiterSuggestionRechercheRequestAction(
        suggestionCaristeFromPoleEmploi(),
        TraiterSuggestionType.accepter,
        location: location,
        rayon: rayon,
      ),
    );
  });

  test("should dispatch refuser suggestion", () {
    // Given
    final store = givenState().withSuggestionsRecherche().spyStore();
    final viewModel = SuggestionRechercheCardViewModel.create(store, suggestionCaristeFromPoleEmploi().id);

    // When
    viewModel?.refuserSuggestion();

    // Then
    expect(viewModel, isNotNull);
    expect(
      store.dispatchedAction,
      TraiterSuggestionRechercheRequestAction(suggestionCaristeFromPoleEmploi(), TraiterSuggestionType.refuser),
    );
  });
}
