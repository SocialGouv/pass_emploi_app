import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class QuestionPageViewModel {
  final String titre;
  final String? information;
  final String question;
  final List<String> options;

  final int? answerSelectedIndex;
  final String? pourquoiAnswer;

  final QuestionBottomButton bottomButton;

  QuestionPageViewModel({
    required this.titre,
    required this.information,
    required this.question,
    required this.options,
    required this.answerSelectedIndex,
    required this.pourquoiAnswer,
    required this.bottomButton,
  });

  factory QuestionPageViewModel.create(Store<AppState> store, int pageOffset) {
    return QuestionPageViewModel(
      titre: "Votre expérience 1/2",
      information: "Les questions marquées d'une * sont obligatoires",
      question: "Aimez-vous Perceval ?",
      options: ["Ouais c'est pas faux"],
      answerSelectedIndex: null,
      pourquoiAnswer: null,
      bottomButton: QuestionBottomButton.next,
    );
  }
}

enum QuestionBottomButton { next, validate }

class ReponsesCampagneState {}
