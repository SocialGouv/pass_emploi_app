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
        Option(id: 1, libelle: "Non"),
      ]),
    ],
  );

  group('Question Page', () {

    test('should display first unanswered question', () {
      // Given
      final store = givenState().loggedInUser().store();

      // When
      final viewModel = QuestionPageViewModel(store, 0);

      // Then
      expect(viewModel.titre, "Votre expérience 1/2");
      expect(viewModel.information, "Les questions marquées d'une * sont obligatoires");
      expect(viewModel.question, "Aimez-vous Perceval ?");
      expect(viewModel.options, ["Ouais c'est pas faux"]);
      expect(viewModel.answerSelectedIndex, null);
      expect(viewModel.pourquoiAnswer, null);
      expect(viewModel.bottomButton, QuestionBottomButton.next);
    });
  });
}
