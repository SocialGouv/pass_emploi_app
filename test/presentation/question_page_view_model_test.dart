import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/presentation/question_page_view_model.dart';

import '../dsl/app_state_dsl.dart';

void main() {
  final campagneWithTwoQuestions = Campagne(
    id: "117-343",
    titre: "Un sondage sur Kaamelott",
    description: "Vos personnages préférés",
    questions: [
      Question(id: 1, libelle: "Aimez-vous Perceval ?", options: [
        Option(id: 1, libelle: "Ouais c'est pas faux"),
      ]),
      Question(id: 2, libelle: "Aimez-vous Arthur ?", options: [
        Option(id: 1, libelle: "Oui"),
        Option(id: 2, libelle: "Non"),
      ]),
    ],
  );

  group('Question Page', () {
    test('should display first question', () {
      // Given
      final store = givenState().loggedInMiloUser().campagne(campagneWithTwoQuestions).store();

      // When
      final viewModel = QuestionPageViewModel.create(store, 0);

      // Then
      expect(viewModel.titre, "Votre expérience 1/2");
      expect(viewModel.question, "Aimez-vous Perceval ?");
      expect(viewModel.options, ["Ouais c'est pas faux"]);
    });

    test('should display second question (last one)', () {
      // Given
      final store = givenState().loggedInMiloUser().campagne(campagneWithTwoQuestions).store();

      // When
      final viewModel = QuestionPageViewModel.create(store, 1);

      // Then
      expect(viewModel.titre, "Votre expérience 2/2");
      expect(viewModel.question, "Aimez-vous Arthur ?");
      expect(viewModel.options, ["Oui", "Non"]);
    });

    test('should display next button when there is more questions', () {
      // Given
      final store = givenState().loggedInMiloUser().campagne(campagneWithTwoQuestions).store();

      // When
      final viewModel = QuestionPageViewModel.create(store, 0);

      // Then
      expect(viewModel.bottomButton, QuestionBottomButton.next);
    });

    test('should display valid button on last page', () {
      // Given
      final store = givenState().loggedInMiloUser().campagne(campagneWithTwoQuestions).store();

      // When
      final viewModel = QuestionPageViewModel.create(store, 1);

      // Then
      expect(viewModel.bottomButton, QuestionBottomButton.validate);
    });

    test('should display informations on first page', () {
      // Given
      final store = givenState().loggedInMiloUser().campagne(campagneWithTwoQuestions).store();

      // When
      final viewModel = QuestionPageViewModel.create(store, 0);

      // Then
      expect(viewModel.information, "Les questions marquées d'une * sont obligatoires");
    });

    test('should not display informations on other pages than first', () {
      // Given
      final store = givenState().loggedInMiloUser().campagne(campagneWithTwoQuestions).store();

      // When
      final viewModel = QuestionPageViewModel.create(store, 1);

      // Then
      expect(viewModel.information, null);
    });

    // todo tests PE
  });
}
